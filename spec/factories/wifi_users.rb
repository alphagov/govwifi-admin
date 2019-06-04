FactoryBot.define do
  factory :wifi_user do
    sequence :contact do |n|
      "test#{n}@gov.uk"
    end

    username { ('a'..'z').to_a.sample(6).join }

    trait :phone_contact do
      sequence :contact do |n|
        "+44#{Array.new(10, n)}"
      end
    end
  end
end
