FactoryBot.define do
  factory :organisation do
    name { Faker::Company.name }
    service_email { Faker::Internet.email }
  end
end
