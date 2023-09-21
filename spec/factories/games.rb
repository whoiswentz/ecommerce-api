FactoryBot.define do
  factory :game do
    mode { Game.modes.keys.sample }
    release_date { "2023-09-21 13:27:40" }
    developer { Faker::Company.name }
    system_requirement
  end
end
