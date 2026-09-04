class AddCompanyReferenceToClients < ActiveRecord::Migration[8.1]
  def change
    remove_column :clients, :company, :string
    add_reference :clients, :company, foreign_key: true
  end
end