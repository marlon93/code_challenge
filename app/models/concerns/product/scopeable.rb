class Product
  module Scopeable
    extend ActiveSupport::Concern

    included do
      default_scope { order(name: :asc) }

      scope :with_stock, -> { where(stock: 1..) }
    end
  end
end
