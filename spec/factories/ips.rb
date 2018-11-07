FactoryBot.define do
  factory :ip do
    sequence :address do |n|
      "10.0.0.#{n}"
    end

    association :location
  end
end
