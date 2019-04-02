FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gov.uk"
    end
    password { '123456' }
    name { "bob" }
    confirmed_at { Time.zone.now }

    association :organisation
    trait :super_admin do
      association :organisation, super_admin: true
    end
    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
