class ClientBriefingService
  class Error < StandardError; end
  class ApiError < Error; end
  class InvalidResponseError < Error; end

  def initialize(notes, client: nil)
    @notes = notes
    @client = client || OpenAI::Client.new(
      access_token: Rails.application.credentials.dig(:openrouter, :api_key),
      uri_base: "https://openrouter.ai/api/v1"
    )
  end

  def call
    response = @client.chat(
  parameters: {
    model: "openai/gpt-4o-mini",
    messages: [
      {
        role: "system",
        content: ClientBriefingPrompt::SYSTEM_PROMPT
      },
      {
        role: "user",
        content: ClientBriefingPrompt.user_prompt(@notes)
      }
    ],
    temperature: 0.3,
    response_format: {
      type: "json_object"
    }
  }
)

    content = response.dig("choices", 0, "message", "content")

    raise InvalidResponseError, "AI response did not contain content" if content.blank?

    JSON.parse(content)
  rescue OpenAI::AuthenticationError => e
    raise ApiError, "OpenAI authentication failed: #{e.message}"
  rescue Faraday::ClientError => e
    raise ApiError, "OpenAI API request failed: #{e.message}"
  rescue Faraday::ServerError => e
    raise ApiError, "OpenAI API server error: #{e.message}"
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    raise ApiError, "OpenAI connection failed: #{e.message}"
  rescue JSON::ParserError => e
    raise InvalidResponseError, "AI returned invalid JSON: #{e.message}"
  end
end