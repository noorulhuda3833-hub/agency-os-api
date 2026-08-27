class NotesChannel < ApplicationCable::Channel
  def subscribed
    client_id = params[:client_id]

    stream_from "client_#{client_id}_notes"
  end

  def unsubscribed
    # Cleanup when subscription ends
  end
end