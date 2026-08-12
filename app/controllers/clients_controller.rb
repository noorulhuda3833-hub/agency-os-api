class ClientsController < ApplicationController
  def index
    workspace = Workspace.find(params[:workspace_id])
    @clients = workspace.clients
  end

  def show
    workspace = Workspace.find(params[:workspace_id])
    @client = workspace.clients.find(params[:id])
  end

  def create
    workspace = Workspace.find(params[:workspace_id])

    @client = workspace.clients.new(client_params)

    if @client.save
      render :show, status: :created
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.permit(:name, :email, :phone, :company)
  end
end