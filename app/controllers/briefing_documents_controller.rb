class BriefingDocumentsController < ApplicationController
  before_action :authenticate_request
  before_action :set_workspace
  before_action :set_client

  def index
    briefing_documents = @client.briefing_documents.order(created_at: :desc)

    render json: briefing_documents, status: :ok
  end

  def create
    briefing_document = @client.briefing_documents.create!(
      content: briefing_params[:content]
    )

    render json: briefing_document, status: :created
  end

  private

  def set_workspace
    @workspace = @current_user.workspaces.find_by(id: params[:workspace_id])

    unless @workspace
      render json: { error: "Workspace not found" }, status: :not_found
    end
  end

  def set_client
    @client = @workspace.clients.find_by(id: params[:client_id])

    unless @client
      render json: { error: "Client not found" }, status: :not_found
    end
  end

  def briefing_params
    params.permit(content: {})
  end
end
