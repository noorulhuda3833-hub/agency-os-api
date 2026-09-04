class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :company
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end


#add db validations
# add company table