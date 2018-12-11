FactoryBot.define do
  factory :organisation do
    name { Faker::Company.unique.name }
    service_email { Faker::Internet.email }
  end
end
