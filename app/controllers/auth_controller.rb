class AuthController < ApplicationController
before_action :authenticate_request, only: [ :update_profile ]

def signup
user = User.new(user_params)


if user.save
  token = JsonWebToken.encode(user_id: user.id)

  render json: {
    message: "User created successfully",
    token: token,
    user: user.as_json(except: [ :password_digest ])
  }, status: :created
else
  render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
end


end

def login
user = User.find_by(email: params[:email])


if user&.authenticate(params[:password])
  token = JsonWebToken.encode(user_id: user.id)

  render json: {
    message: "Login successful",
    token: token,
    user: user.as_json(except: [ :password_digest ])
  }, status: :ok
else
  render json: {
    error: "Invalid email or password"
  }, status: :unauthorized
end


end

def update_profile
if @current_user.update(profile_params)
render json: {
message: "Profile updated successfully",
user: @current_user.as_json(except: [ :password_digest ])
}, status: :ok
else
render json: {
errors: @current_user.errors.full_messages
}, status: :unprocessable_entity
end
end

private

def user_params
params.permit(:name, :email, :password, :password_confirmation)
end

def profile_params
params.permit(:name, :email)
end
end
