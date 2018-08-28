FactoryBot.define do
  factory :user do
    email { "test@gov.uk" }
    password { "123456" }
    name { "bob" }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end
  end
end
