class ClientBriefingService
  def initialize(notes)
    @notes = notes
    @client = OpenAI::Client.new(
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
        temperature: 0.3
      }
    )

    content = response.dig("choices", 0, "message", "content")

    JSON.parse(content)
  end
end
