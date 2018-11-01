FactoryBot.define do
  factory :ip do
    address { '10.0.0.1' }
    association :location
  end
end
