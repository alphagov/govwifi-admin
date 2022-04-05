FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gov.uk"
    end
    password { "strong lemonade 1475 p4o6d09" }
    name { "bob" }
    confirmed_at { Time.zone.now }

    trait :super_admin do
      is_super_admin { true }
    end

    trait :with_organisation do
      after(:create) do |user|
        create(:organisation, users: [user])
      end
    end

    trait :with_organisation_and_locations do
      after(:create) do |user|
        create(:organisation, :with_locations, users: [user])
      end
    end

    trait :with_2fa do
      otp_secret_key { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" } # 2FA is set up
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
