FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    os { Faker::Computer.os }
    storage { "5GB" }
    cpu { "AMD Ryzen 7" }
    memory { "2GB" }
    gpu { "N/A" }
  end
end
