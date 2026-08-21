class DashboardController < ApplicationController
  before_action :authenticate_request

  def index
    render json: {
      message: "Welcome #{@current_user.name}",
      user: @current_user.as_json(except: [ :password_digest ])
    }
  end
end
