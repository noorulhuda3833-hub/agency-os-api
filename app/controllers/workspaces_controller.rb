class WorkspacesController < ApplicationController
  before_action :authenticate_request

  def index
    workspaces = @current_user.workspaces
    render json: workspaces
  end

  def show
    workspace = @current_user.workspaces.find(params[:id])
    render json: workspace
  end

  def create
    workspace = @current_user.workspaces.new(workspace_params)

    if workspace.save
      render json: workspace, status: :created
    else
      render json: { errors: workspace.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    workspace = @current_user.workspaces.find(params[:id])

    if workspace.update(workspace_params)
      render json: workspace
    else
      render json: { errors: workspace.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    workspace = @current_user.workspaces.find(params[:id])
    workspace.destroy

    head :no_content
  end

  private

  def workspace_params
    params.permit(:name)
  end
end