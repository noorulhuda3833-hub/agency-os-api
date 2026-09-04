class CompaniesController < ApplicationController
  def index
    @companies = Company.order(:name)

    render json: @companies
  end

  def create
    @company = Company.find_or_initialize_by(name: company_params[:name].strip)

    if @company.save
      render json: @company, status: :created
    else
      render json: {
        errors: @company.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.permit(:name)
  end
end