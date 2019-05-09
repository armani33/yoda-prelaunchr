class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.monetize :price, currency: { present: false}

      t.timestamps
    end
  end
end
