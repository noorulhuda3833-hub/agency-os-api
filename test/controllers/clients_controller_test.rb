require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
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

    token = JsonWebToken.encode(user_id: @user.id)
    @headers = {
      "Authorization" => "Bearer #{token}"
    }
  end

  test "should get index" do
    get workspace_clients_url(@workspace),
        headers: @headers,
        as: :json

    assert_response :success
  end

  test "should show client" do
    get workspace_client_url(@workspace, @client),
        headers: @headers,
        as: :json

    assert_response :success
  end

  test "should create client" do
    company = Company.create!(
      name: "Apple Inc."
    )

    assert_difference("Client.count", 1) do
      post workspace_clients_url(@workspace),
           params: {
             name: "Apple",
             email: "apple@gmail.com",
             phone: "03123456789",
             company_id: company.id
           },
           headers: @headers,
           as: :json
    end

    assert_response :created
  end

  test "should update client" do
    patch workspace_client_url(@workspace, @client),
          params: {
            name: "Nike Updated"
          },
          headers: @headers,
          as: :json

    assert_response :success

    @client.reload
    assert_equal "Nike Updated", @client.name
  end

  test "should destroy client" do
    assert_difference("Client.count", -1) do
      delete workspace_client_url(@workspace, @client),
             headers: @headers,
             as: :json
    end

    assert_response :no_content
  end

  test "should not update client with invalid data" do
    patch workspace_client_url(@workspace, @client),
          params: {
            name: ""
          },
          headers: @headers,
          as: :json

    assert_response :unprocessable_entity
  end
end
