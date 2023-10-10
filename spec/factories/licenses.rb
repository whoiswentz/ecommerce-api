FactoryBot.define do
  factory :license do
    sequence(:key) { |n| "key#{n}" }
    license_platform { "xbox" }
    license_status { "pending_creation" }

    after :build do |license|
      license.game = create(:game)
    end
  end
end
