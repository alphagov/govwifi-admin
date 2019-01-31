FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gov.uk"
    end
    password { '123456' }
    name { "bob" }
    confirmed_at { Time.zone.now }

    association :organisation
    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
