FactoryBot.define do
  factory :x509_certificate, class: String do
    key { OpenSSL::PKey::RSA.new(512) }
    issuing_key { key }
    issuing_subject { "/CN=Certificate_1" }
    not_before { Time.zone.now }
    not_after { Time.zone.now + 7 * 4 }
    sequence(:subject) do |n|
      "/CN=Certificate_#{n}"
    end
    sequence(:serial) do |n|
      "12345#{n}"
    end

    initialize_with do
      result = OpenSSL::X509::Certificate.new.tap do |certificate|
        certificate.public_key = key.public_key
        certificate.serial = OpenSSL::BN.new(serial)
        certificate.subject = OpenSSL::X509::Name.parse(subject)
        certificate.issuer =  OpenSSL::X509::Name.parse(issuing_subject)
        certificate.not_before = not_before
        certificate.not_after = not_after
        certificate.extensions = [
          OpenSSL::X509::ExtensionFactory.new.create_extension("basicConstraints", "CA:TRUE", true),
        ]
        certificate.sign issuing_key, OpenSSL::Digest.new("SHA1")
      end
      result.to_pem
    end
  end
end
