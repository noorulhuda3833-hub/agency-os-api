module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def not_found
    render json: { error: "Record not found" }, status: :not_found
  end
end
