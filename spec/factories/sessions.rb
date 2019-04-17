FactoryBot.define do
  factory :session do
    sequence :siteIP do |n|
      fourth = n % 255
      third = n / 255
      "141.0.#{third}.#{fourth}"
    end
  end
end
