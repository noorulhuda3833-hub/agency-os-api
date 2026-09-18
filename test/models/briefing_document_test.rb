require "test_helper"

class BriefingDocumentTest < ActiveSupport::TestCase
  setup do
    user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password"
    )

    workspace = Workspace.create!(
      name: "Test Workspace",
      user: user
    )

    company = Company.create!(
      name: "Test Company"
    )

    @client = Client.create!(
      name: "Test Client",
      email: "client@example.com",
      phone: "12345678901",
      company: company,
      workspace: workspace
    )
  end

  test "is valid with a client and content" do
    briefing_document = BriefingDocument.new(
      client: @client,
      content: { "client_summary" => "Test briefing" }
    )

    assert briefing_document.valid?
  end

  test "is invalid without content" do
    briefing_document = BriefingDocument.new(client: @client)

    assert_not briefing_document.valid?
  end

  test "stores briefing content as json" do
    briefing_document = BriefingDocument.create!(
      client: @client,
      content: {
        "client_summary" => "Test briefing",
        "key_points" => [ "Website redesign" ]
      }
    )

    saved_document = BriefingDocument.find(briefing_document.id)

    assert_equal "Test briefing", saved_document.content["client_summary"]
    assert_equal [ "Website redesign" ], saved_document.content["key_points"]
  end
end