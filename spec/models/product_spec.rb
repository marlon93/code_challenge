require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    let!(:product_with_stock) { create(:product, stock: 10) }
    let!(:product_without_stock) { create(:product, stock: 0) }

    describe '.with_stock' do
      it 'returns only products with stock greater than 0' do
        expect(Product.with_stock).to include(product_with_stock)
        expect(Product.with_stock).not_to include(product_without_stock)
      end
    end

    describe 'default scope' do
      before { Product.destroy_all }

      let!(:product_b) { create(:product, name: 'B Item') }
      let!(:product_a) { create(:product, name: 'A Item') }

      it 'orders products by name in ascending order' do
        expect(Product.all).to eq([product_a, product_b])
      end
    end
  end
end
