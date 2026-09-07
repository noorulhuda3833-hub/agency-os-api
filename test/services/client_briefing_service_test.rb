require "test_helper"

class ClientBriefingServiceTest < ActiveSupport::TestCase
  FakeClient = Struct.new(:response, :error) do
    def chat(parameters:)
      raise error if error

      response
    end
  end

  setup do
    @notes = [
      Note.new(
        note_type: "meeting",
        title: "Website discussion",
        content: "Client wants a modern website for a coffee brand."
      )
    ]
  end

  test "returns parsed briefing when API response is valid JSON" do
    response = {
      "choices" => [
        {
          "message" => {
            "content" => '{"summary":"Modern coffee brand website","priorities":["branding","modern design"]}'
          }
        }
      ]
    }

    client = FakeClient.new(response, nil)
    service = ClientBriefingService.new(@notes, client: client)

    result = service.call

    assert_equal "Modern coffee brand website", result["summary"]
    assert_equal [ "branding", "modern design" ], result["priorities"]
  end

  test "raises JSON parser error when API returns invalid JSON" do
    response = {
      "choices" => [
        {
          "message" => {
            "content" => "invalid json response"
          }
        }
      ]
    }

    client = FakeClient.new(response, nil)
    service = ClientBriefingService.new(@notes, client: client)

    error = assert_raises(ClientBriefingService::InvalidResponseError) do
      service.call
    end

    assert_includes error.message, "AI returned invalid JSON"
  end

  test "raises Faraday error when API request fails" do
    error = Faraday::ConnectionFailed.new("API connection failed")

    client = FakeClient.new(nil, error)
    service = ClientBriefingService.new(@notes, client: client)

    api_error = assert_raises(ClientBriefingService::ApiError) do
      service.call
    end

    assert_includes api_error.message, "OpenAI connection failed"
  end

  test "raises API error when API rate limit is exceeded" do
    response = Faraday::Response.new(
      status: 429,
      response_body: '{"error":{"message":"Rate limit exceeded"}}'
    )

    error = Faraday::ClientError.new(
      "Rate limit exceeded",
      response: response
    )

    client = FakeClient.new(nil, error)
    service = ClientBriefingService.new(@notes, client: client)

    api_error = assert_raises(ClientBriefingService::ApiError) do
      service.call
    end

    assert_includes api_error.message, "OpenAI API request failed"
  end
end
