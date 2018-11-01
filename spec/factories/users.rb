FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gov.uk"
    end
    password { '123456' }
    password_confirmation { '123456' }
    name { "bob" }
    association :organisation

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end
  end
end
