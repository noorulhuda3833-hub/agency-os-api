class CreateBriefingDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :briefing_documents do |t|
      t.references :client, null: false, foreign_key: true
      t.jsonb :content, null: false

      t.timestamps
    end
  end
end
