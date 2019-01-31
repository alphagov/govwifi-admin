FactoryBot.define do
  factory :organisation do
    sequence :name do |n|
      "Org #{n}"
    end

    service_email { Faker::Internet.email }

    trait :with_locations do
      after :create do |org|
        create_list :location, 3, organisation: org
      end
    end
  end
end
