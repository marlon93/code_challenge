FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 10.0..500.0, as_string: false) }
    stock { Faker::Number.between(from: 1, to: 100) }
    created_at { Time.current }
    updated_at { Time.current }

    trait :out_of_stock do
      stock { 0 }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 1000.0..5000.0, as_string: false) }
    end

    trait :cheap do
      price { Faker::Commerce.price(range: 1.0..10.0, as_string: false) }
    end
  end
end
