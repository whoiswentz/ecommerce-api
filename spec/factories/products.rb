FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "PRODUCT #{n}"}
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }
    sequence(:sku) { |n| "SKU#{n}"}
    producttable { nil }
  end
end
