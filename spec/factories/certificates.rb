FactoryBot.define do
  factory :certificate do
    trait :from_cert_file do
    end

    trait :with_intermediate_cert_file do
      before :create do |cert|
        cert.name = "my_intermediate_cert"
        cert.import_from_x509_file("spec/models/intermediate_ca.pem")
      end
    end

    trait :with_intermediate_cert_file_and_org do
      before :create do |cert|
        cert.name = "my_intermediate_cert"
        cert.organisation = create(:organisation, :with_cba_enabled)
        cert.import_from_x509_file("spec/models/intermediate_ca.pem")
      end
    end

    trait :with_root_cert_file_and_org do
      before :create do |cert|
        cert.name = "my_root_cert"
        cert.organisation = create(:organisation, :with_cba_enabled)
        cert.import_from_x509_file("spec/models/root_ca.pem")
      end
    end
  end
end
