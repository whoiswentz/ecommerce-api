FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "PRODUCT #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }
    image {
      Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/image.jpg"))
    }
    product_status { Product::product_statuses.keys.sample }

    after :build do |product|
      product.productable = create(:game)
    end
  end
end
