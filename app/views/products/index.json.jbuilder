json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :stock
  json.url product_url(product, format: :json)
end
