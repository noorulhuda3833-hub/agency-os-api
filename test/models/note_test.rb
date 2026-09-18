require "test_helper"

class NoteTest < ActiveSupport::TestCase
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

  test "valid note is valid" do
    note = Note.new(
      client: @client,
      title: "Test Note",
      content: "Test content",
      note_type: "meeting"
    )

    assert note.valid?
  end

  test "note requires a title" do
    note = Note.new(
      client: @client,
      title: nil,
      content: "Test content",
      note_type: "meeting"
    )

    assert_not note.valid?
    assert_includes note.errors[:title], "can't be blank"
  end

  test "note requires content" do
    note = Note.new(
      client: @client,
      title: "Test Note",
      content: nil,
      note_type: "meeting"
    )

    assert_not note.valid?
    assert_includes note.errors[:content], "can't be blank"
  end

  test "note requires a valid note type" do
    note = Note.new(
      client: @client,
      title: "Test Note",
      content: "Test content",
      note_type: "invalid"
    )

    assert_not note.valid?
    assert note.errors[:note_type].any?
  end

  test "note accepts valid note types" do
    %w[meeting call email task general].each do |note_type|
      note = Note.new(
        client: @client,
        title: "Test Note",
        content: "Test content",
        note_type: note_type
      )

      assert note.valid?, "#{note_type} should be a valid note type"
    end
  end

  test "note belongs to a client" do
    note = Note.new(
      client: @client,
      title: "Test Note",
      content: "Test content",
      note_type: "meeting"
    )

    assert_respond_to note, :client
    assert_equal @client, note.client
  end
end
