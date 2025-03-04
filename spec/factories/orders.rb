FactoryBot.define do
  factory :order do
    association :product
    customer_name { Faker::Name.name }
    status { Order::STATUS.index('processing') }
    carrier_id { Faker::Number.number(digits: 6) }
    carrier_name { 'Fedex' }
    created_at { Time.current }
    updated_at { Time.current }

    trait :processing do
      status { Order::STATUS.index('processing') }
    end

    trait :awaiting_pickup do
      status { Order::STATUS.index('awaiting_pickup') }
    end

    trait :in_transit do
      status { Order::STATUS.index('in_transit') }
    end

    trait :out_for_delivery do
      status { Order::STATUS.index('out_for_delivery') }
    end

    trait :delivered do
      status { Order::STATUS.index('delivered') }
    end

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
