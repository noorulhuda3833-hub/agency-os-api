require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Noor",
      email: "noor@example.com",
      password: "password"
    )

    @workspace = Workspace.create!(
      name: "Development",
      user: @user
    )

    @company = Company.create!(
      name: "Nike Inc."
    )

    @client = Client.create!(
      name: "Nike",
      email: "nike@gmail.com",
      phone: "03001234567",
      company: @company,
      workspace: @workspace
    )

    @note = Note.create!(
      title: "Client Meeting",
      content: "Discussed project requirements",
      note_type: "meeting",
      client: @client
    )

    @token = JsonWebToken.encode(user_id: @user.id)

    @headers = {
      "Authorization" => "Bearer #{@token}"
    }
  end

  test "should get notes index" do
    get workspace_client_notes_url(@workspace, @client),
        headers: @headers,
        as: :json

    assert_response :success

    response_data = JSON.parse(response.body)

    assert_equal 1, response_data.length
    assert_equal @note.id, response_data.first["id"]
  end

  test "should create note" do
    assert_difference("Note.count", 1) do
      post workspace_client_notes_url(@workspace, @client),
           params: {
             note: {
               title: "Follow Up",
               content: "Send proposal to client",
               note_type: "task"
             }
           },
           headers: @headers,
           as: :json
    end

    assert_response :created

    response_data = JSON.parse(response.body)

    assert_equal "Follow Up", response_data["title"]
    assert_equal "Send proposal to client", response_data["content"]
    assert_equal "task", response_data["note_type"]
  end

  test "should show note" do
    get workspace_client_note_url(@workspace, @client, @note),
        headers: @headers,
        as: :json

    assert_response :success

    response_data = JSON.parse(response.body)

    assert_equal @note.id, response_data["id"]
    assert_equal "Client Meeting", response_data["title"]
    assert_equal "meeting", response_data["note_type"]
  end

  test "should update note" do
    patch workspace_client_note_url(@workspace, @client, @note),
          params: {
            note: {
              title: "Updated Meeting",
              content: "Updated meeting notes",
              note_type: "call"
            }
          },
          headers: @headers,
          as: :json

    assert_response :success

    @note.reload

    assert_equal "Updated Meeting", @note.title
    assert_equal "Updated meeting notes", @note.content
    assert_equal "call", @note.note_type
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete workspace_client_note_url(@workspace, @client, @note),
             headers: @headers,
             as: :json
    end

    assert_response :success
  end

  test "should not create note with invalid note type" do
    assert_no_difference("Note.count") do
      post workspace_client_notes_url(@workspace, @client),
           params: {
             note: {
               title: "Invalid Note",
               content: "Some content",
               note_type: "invalid"
             }
           },
           headers: @headers,
           as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should not create note without title" do
    assert_no_difference("Note.count") do
      post workspace_client_notes_url(@workspace, @client),
           params: {
             note: {
               title: "",
               content: "Some content",
               note_type: "general"
             }
           },
           headers: @headers,
           as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should return not found for missing note" do
    get workspace_client_note_url(@workspace, @client, 999999),
        headers: @headers,
        as: :json

    assert_response :not_found

    response_data = JSON.parse(response.body)

    assert_equal "Note not found", response_data["error"]
  end
end
