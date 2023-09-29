FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Coupon #{n}" }
    code { Faker::Commerce.unique.promotion_code(digits: 6) }
    coupon_status { Coupon::coupon_statuses.keys.sample }
    discount_value { rand(1..99) }
    max_use { rand(1..99) }
    due_date { 3.days.from_now }
  end
end
