FactoryBot.define do
  factory :organisation do
    name { Faker::Company.name }
  end
end
