FactoryBot.define do
  factory :user do
    email { "test@gov.uk" }
    password { "123456" }
    name { "bob" }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end

    trait :with_organisation do
      association :organisation
    end
  end
end
