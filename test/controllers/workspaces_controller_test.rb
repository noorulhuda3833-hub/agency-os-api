require "test_helper"

class WorkspacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Noor",
      email: "noor@example.com",
      password: "password"
    )

    @other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "password"
    )

    @workspace = Workspace.create!(
      name: "Noor Workspace",
      user: @user
    )

    @other_user_token = JsonWebToken.encode(user_id: @other_user.id)

    @headers = {
      "Authorization" => "Bearer #{@other_user_token}"
    }
  end

  test "user cannot access another user's workspace" do
    get workspace_url(@workspace),
        headers: @headers,
        as: :json

    assert_response :not_found
  end
end