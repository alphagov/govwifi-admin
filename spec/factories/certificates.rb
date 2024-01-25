FactoryBot.define do
  factory :certificate do
    trait :from_cert_file do
    end

    trait :with_cert_file_and_org do
      before :create do |cert|
        cert.name = "mycert"
        org = create(:organisation)
        cert.organisation = org
        cert.import_from_x509_file("spec/models/comodoCA.pem")
      end
    end
  end
end
