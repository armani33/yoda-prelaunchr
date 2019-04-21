class CreateIpAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_addresses do |t|
      t.string :address
      t.integer :count

      t.timestamps
    end
  end
end
