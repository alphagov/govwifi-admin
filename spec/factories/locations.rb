FactoryBot.define do
  factory :location do
    address { Faker::Address.street_address }
    postcode { Faker::Address.zip_code }
    association :organisation
  end
end
