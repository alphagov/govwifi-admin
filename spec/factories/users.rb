FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gov.uk"
    end
    sequence :password do |n|
      "#{n}123456#{n}"
    end
    name { "bob" }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end

    trait :with_organisation do
      association :organisation
    end
  end
end
