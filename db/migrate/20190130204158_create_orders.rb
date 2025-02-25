class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :product, foreign_key: true
      t.string :customer_name
      t.string :adress
      t.string :zip_code
      t.string :shipping_method

      t.timestamps
    end
  end
end
