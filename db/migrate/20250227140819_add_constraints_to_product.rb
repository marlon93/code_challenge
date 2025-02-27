class AddConstraintsToProduct < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :products, 'price >= 0', name: 'products_price_check'
    add_check_constraint :products, 'stock >= 0', name: 'products_stock_check'
  end
end
