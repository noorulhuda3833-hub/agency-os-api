class NotesController < ApplicationController
before_action :authenticate_request
  before_action :set_workspace
  before_action :set_client

  def index
  notes = @client.notes

  render json: notes.map { |note|
    {
      id: note.id,
      client_id: note.client_id,
      title: note.title,
      content: note.content,
      note_type: note.note_type
    }
  }, status: :ok
end

  def create
  note = @client.notes.new(note_params)

  if note.save
    render json: {
      id: note.id,
      client_id: note.client_id,
      title: note.title,
      content: note.content,
      note_type: note.note_type
    }, status: :created
  else
    render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
  end
end
def note_params
  params.require(:note).permit(:title, :content, :note_type)
end

def show
  note = @client.notes.find_by(id: params[:id])

  unless note
    return render json: { error: "Note not found" }, status: :not_found
  end

  render json: {
    id: note.id,
    client_id: note.client_id,
    title: note.title,
    content: note.content,
    note_type: note.note_type,
    files: note.files.map do |file|
      {
        id: file.id,
        filename: file.filename.to_s,
        content_type: file.content_type,
        byte_size: file.byte_size
      }
    end
  }, status: :ok
end

def update
  note = @client.notes.find_by(id: params[:id])

  unless note
    return render json: { error: "Note not found" }, status: :not_found
  end

  if note.update(note_params)
    render json: {
      message: "Note updated successfully",
      note: {
        id: note.id,
        client_id: note.client_id,
        title: note.title,
        content: note.content,
        note_type: note.note_type,
        files: note.files.map do |file|
          {
            id: file.id,
            filename: file.filename.to_s,
            content_type: file.content_type,
            byte_size: file.byte_size
          }
        end
      }
    }, status: :ok
  else
    render json: {
      errors: note.errors.full_messages
    }, status: :unprocessable_entity
  end
end

def destroy
  note = @client.notes.find_by(id: params[:id])

  unless note
    return render json: { error: "Note not found" }, status: :not_found
  end

  note.destroy

  render json: {
    message: "Note deleted successfully"
  }, status: :ok
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
end