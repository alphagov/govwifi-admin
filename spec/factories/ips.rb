FactoryBot.define do
  factory :ip do
    sequence :address do |n|
      fourth = n % 255
      third = n / 255
      "141.0.#{third}.#{fourth}"
    end
    created_at { 3.days.ago }
    association :location
  end
end
