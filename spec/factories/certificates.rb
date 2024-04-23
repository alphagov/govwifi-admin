FactoryBot.define do
  factory :certificate do
    sequence :name do |n|
      "my_certificate_#{n}"
    end
    fingerprint { "ABCDEF123" }
    content { "A Certificate" }
    subject { "/CN=root" }
    issuer { "/CN=root" }
    not_before { Time.zone.now }
    not_after { Time.zone.now + 7 * 4 }
    serial { "1234567890" }

    trait :with_organisation do
      after :build do |cert|
        cert.organisation = create(:organisation, :with_cba_enabled)
      end
    end
  end
end
