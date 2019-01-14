FactoryBot.define do
  factory :organisation do
    name { Faker::Company.unique.name }
    service_email { Faker::Internet.email }

    trait :with_locations do
      after :create do |org|
        create_list :location, 3, organisation: org
      end
    end
  end
end
