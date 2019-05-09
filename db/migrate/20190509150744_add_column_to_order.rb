class AddColumnToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :email, :string
    rename_column :users, :stripe_id, :stripe_email
  end
end
