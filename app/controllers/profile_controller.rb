class ProfileController < ApplicationController
  before_action :authenticate_request

  def update_password
    current_user = @current_user

    unless current_user&.authenticate(params[:current_password])
      render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
      return
    end

    if params[:new_password].blank?
      render json: { error: "New password cannot be blank" }, status: :unprocessable_entity
      return
    end

    if params[:new_password] != params[:password_confirmation]
      render json: { error: "New passwords do not match" }, status: :unprocessable_entity
      return
    end

    if current_user.update(
      password: params[:new_password],
      password_confirmation: params[:password_confirmation]
    )
      render json: {
        message: "Password updated successfully"
      }, status: :ok
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end