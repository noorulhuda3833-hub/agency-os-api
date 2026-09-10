require "test_helper"

class BriefingDocumentTest < ActiveSupport::TestCase
  test "is valid with a client and content" do
    client = clients(:one)

    briefing_document = BriefingDocument.new(
      client: client,
      content: { "client_summary" => "Test briefing" }
    )

    assert briefing_document.valid?
  end

  test "is invalid without content" do
    client = clients(:one)

    briefing_document = BriefingDocument.new(client: client)

    assert_not briefing_document.valid?
  end

  test "stores briefing content as json" do
  client = clients(:one)

  briefing_document = BriefingDocument.create!(
    client: client,
    content: {
      "client_summary" => "Test briefing",
      "key_points" => ["Website redesign"]
    }
  )

  saved_document = BriefingDocument.find(briefing_document.id)

  assert_equal "Test briefing", saved_document.content["client_summary"]
  assert_equal ["Website redesign"], saved_document.content["key_points"]
end

end