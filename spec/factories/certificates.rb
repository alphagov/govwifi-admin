FactoryBot.define do
  factory :certificate do
    key { OpenSSL::PKey::RSA.new(512) }
    issuing_key { key }
    issuing_subject { subject }
    not_before { Time.zone.now }
    not_after { Time.zone.now + 7 * 4 }
    sequence(:subject) do |n|
      "/CN=Certificate_#{n}"
    end
    sequence(:serial) do |n|
      "12345#{n}"
    end

    organisation { create(:organisation, :with_cba_enabled) }

    sequence(:name) do |n|
      "cert_#{n}"
    end

    initialize_with do
      content = build(:x509_certificate, key:, issuing_subject:, issuing_key:, not_before:, not_after:, subject:, serial:)
      Certificate.parse_certificate(content).tap do |certificate|
        certificate.organisation = organisation
        certificate.name = name
      end
    end
  end
end
