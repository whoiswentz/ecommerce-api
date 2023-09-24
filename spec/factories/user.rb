FactoryBot.define do
  factory :user do
    password = Faker::Internet.password

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    profile { User.profiles.keys.sample }
  end
end