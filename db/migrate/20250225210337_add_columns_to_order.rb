class AddColumnsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :status, :integer
    add_column :orders, :carrier_id, :integer
    add_column :orders, :carrier_name, :string
    add_column :orders, :deleted_at, :datetime
    change_column_null :orders, :product_id, false
    change_column_null :orders, :customer_name, false

    add_index :orders, :status
    add_index :orders, :deleted_at
    add_index :orders, [:carrier_id, :carrier_name], unique: true
  end
end
