FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "PRODUCT #{n}"}
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }
    sequence(:sku) { |n| "SKU#{n}"}
    image {
      Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/image.jpg"))
    }

    after :build do |product|
      product.producttable = create(:game)
    end
  end
end
