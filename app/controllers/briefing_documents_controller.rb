class BriefingDocumentsController < ApplicationController
  def create
    client = Client.find(params[:client_id])

    briefing_document = client.briefing_documents.create!(
      content: briefing_params[:content]
    )

    render json: briefing_document, status: :created
  end

  private

  def briefing_params
    params.permit(content: {})
  end
end