describe CertificateForm do
  let(:root_ca) { CertificateHelper.new.root_ca }
  let(:intermediate_ca) { CertificateHelper.new.intermediate_ca(signed_by: root_ca) }
  let(:organisation) { create(:organisation) }
  let(:name) { "myCert" }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:file) }

  describe "unique name" do
    it "is valid because there is no Certificate with the same name in the organisation" do
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to be_valid
    end
    it "is valid because there is a Certificate with the same name but in a different organisation" do
      create(:certificate, :with_organisation, name:)

      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to be_valid
    end
    it "is invalid because there is a Certificate with the same name in the organisation" do
      create(:certificate, name:, organisation:)
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to_not be_valid
      expect(certificate.errors.of_kind?(:name, :taken)).to be true
    end
  end

  describe "unique fingerprint" do
    it "is valid because there is no Certificate with the same fingerprint in the organisation" do
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to be_valid
    end
    it "is valid because there is a Certificate with the same name but in a different organisation" do
      create(:certificate, :with_organisation, fingerprint: OpenSSL::Digest::SHA1.new(root_ca.to_der).to_s)

      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to be_valid
    end
    it "is invalid because there is a Certificate with the same name in the organisation" do
      create(:certificate, organisation:, fingerprint: OpenSSL::Digest::SHA1.new(root_ca.to_der).to_s)
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem))
      expect(certificate).to_not be_valid
    end
  end

  describe "create a new certificate" do
    context "a valid certificate" do
      it "creates a new certificate" do
        expect {
          CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem)).save
        }.to change(Certificate, :count).by(1)
      end
      it "The new certificate has the correct attributes" do
        expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca.to_pem)).save).to be true
        new_certificate = Certificate.find_by_name_and_organisation_id(name, organisation.id)
        expect(new_certificate.content).to eq(root_ca.to_pem)
        expect(new_certificate.fingerprint).to eq(OpenSSL::Digest::SHA1.new(root_ca.to_der).to_s)
        expect(new_certificate.subject).to eq(root_ca.subject.to_s)
        expect(new_certificate.issuer).to eq(root_ca.issuer.to_s)
        expect(new_certificate.not_before).to eq(root_ca.not_before)
        expect(new_certificate.not_after).to eq(root_ca.not_after)
        expect(new_certificate.serial).to eq(root_ca.serial.to_s)
      end
    end
    context "an invalid certificate" do
      it "does not create a new certificate" do
        expect {
          CertificateForm.new(name:, organisation:, file: StringIO.new("invalid")).save
        }.to_not change(Certificate, :count)
      end
      it "is invalid" do
        form = CertificateForm.new(name:, organisation:, file: StringIO.new("invalid"))
        expect(form).to_not be_valid
        expect(form.errors.of_kind?(:file, :invalid_certificate)).to be true
      end
      it "returns false" do
        expect(CertificateForm.new(name:, organisation:, file: StringIO.new("invalid")).save).to be false
      end
    end
  end
end
