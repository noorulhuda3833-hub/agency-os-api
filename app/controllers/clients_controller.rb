class ClientsController < ApplicationController
  before_action :set_workspace
  before_action :set_client, only: [ :show, :update, :destroy ]

  def index
    @clients = @workspace.clients
  end

  def show
  end

  def create
    @client = @workspace.clients.new(client_params)

    if @client.save
      render :show, status: :created
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render :show
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
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
    params.permit(:name, :email, :phone, :company)
  end
end
