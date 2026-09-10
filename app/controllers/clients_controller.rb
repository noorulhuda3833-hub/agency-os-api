class ClientsController < ApplicationController
  before_action :set_workspace
before_action :set_client, only: [ :show, :update, :destroy, :briefing ]

  def index
    @clients = @workspace.clients.includes(:company)
  end

  def show
  end

def briefing
  notes = @client.notes

  result = ClientBriefingService.new(notes).call

  briefing_document = @client.briefing_documents.create!(
    content: result
  )

  render json: briefing_document, status: :created
rescue ClientBriefingService::InvalidResponseError => e
  render json: { error: e.message }, status: :unprocessable_entity
rescue ClientBriefingService::ApiError => e
  render json: { error: e.message }, status: :bad_gateway
end




  def companies
    @companies = Company.all.order(:name)

    render json: @companies
  end

  def create
    @client = @workspace.clients.new(client_params)

    if @client.save
      render :show, status: :created
    else
      render json: {
        errors: @client.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render :show
    else
      render json: {
        errors: @client.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    head :no_content
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def set_client
    @client = @workspace.clients.find(params[:id])
  end

  def client_params
    params.permit(
      :name,
      :email,
      :phone,
      :company_id
    )
  end
end
