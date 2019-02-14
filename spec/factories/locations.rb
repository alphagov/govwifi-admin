FactoryBot.define do
  factory :location do
    address { Faker::Address.street_address }
    postcode { Faker::Address.postcode }
    association :organisation
  end
end
