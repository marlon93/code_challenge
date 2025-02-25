class Product < ActiveRecord::Base
  STATUS = ['processing'].concat(Fedex::STATUS).freeze
end
