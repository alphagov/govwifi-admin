FactoryBot.define do
  factory :mou do
    job_role { "HR" }
    name { "Joe" }
    email_address { "joe@gov.uk" }
    sequence :version do |n|
      "1.#{n}"
    end
  end
end
