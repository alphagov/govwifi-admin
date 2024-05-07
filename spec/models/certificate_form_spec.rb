describe CertificateForm do
  let(:next_week) { Time.zone.now.days_since(7) }
  let(:last_week) { Time.zone.now.days_ago(7) }
  let(:serial) { "12345" }
  let(:root_subject) { "/CN=rootca" }
  let(:intermediate_subject) { "/CN=intermediateca" }
  let(:root_key) { OpenSSL::PKey::RSA.new(512) }
  let(:intermediate_key) { OpenSSL::PKey::RSA.new(512) }
  let(:root_ca) do
    build(:x509_certificate,
          key: root_key,
          subject: root_subject,
          issuing_subject: root_subject,
          not_before: last_week,
          not_after: next_week,
          serial:)
  end
  let(:intermediate_ca) do
    build(:x509_certificate,
          subject: intermediate_subject,
          key: intermediate_key,
          issuing_key: root_key,
          issuing_subject: root_subject,
          serial:)
  end
  let(:organisation) { create(:organisation) }
  let(:name) { "myCert" }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:file) }

  describe "unique name" do
    it "is valid because there is no Certificate with the same name in the organisation" do
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca))
      expect(certificate).to be_valid
    end
    it "is valid because there is a Certificate with the same name but in a different organisation" do
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save).to be true
      expect(CertificateForm.new(name:, organisation: create(:organisation), file: StringIO.new(root_ca))).to be_valid
    end
    it "is invalid because there is a Certificate with the same name in the organisation" do
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save).to be true
      certificate = CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca))
      expect(certificate).to be_invalid
      expect(certificate.errors.of_kind?(:name, :taken)).to be true
    end
  end

  describe "unique certificate" do
    it "is valid because there is no Certificate with the same fingerprint in the organisation" do
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca))).to be_valid
    end
    it "is valid because there is a Certificate with the same name but in a different organisation" do
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save).to be true
      expect(CertificateForm.new(name:, organisation: create(:organisation), file: StringIO.new(root_ca))).to be_valid
    end
    it "is invalid because there is a Certificate with the same name in the organisation" do
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save).to be true
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca))).to be_invalid
    end
  end

  describe "create a new certificate" do
    context "a valid certificate" do
      it "creates a new certificate" do
        expect {
          CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save
        }.to change(Certificate, :count).by(1)
      end
      it "The new certificate has the correct attributes" do
        expect(CertificateForm.new(name:, organisation:, file: StringIO.new(root_ca)).save).to be true
        new_certificate = Certificate.find_by_name_and_organisation_id(name, organisation.id)
        expect(new_certificate.content).to eq(root_ca)
        expect(new_certificate.fingerprint).to_not be nil
        expect(new_certificate.subject).to eq(root_subject)
        expect(new_certificate.issuer).to eq(root_subject)
        expect(new_certificate.not_before).to be_within(1.second).of(last_week.to_time)
        expect(new_certificate.not_after).to be_within(1.second).of(next_week.to_time)
        expect(new_certificate.serial).to eq(serial)
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
        expect(form).to be_invalid
        expect(form.errors.of_kind?(:file, :invalid_certificate)).to be true
      end
      it "returns false" do
        expect(CertificateForm.new(name:, organisation:, file: StringIO.new("invalid")).save).to be false
      end
    end
  end

  describe "create an intermediate, without a root certificate present" do
    it "is valid because it has a parent" do
      expect(CertificateForm.new(name: "rootCA", organisation:, file: StringIO.new(root_ca)).save).to be true
      expect(CertificateForm.new(name:, organisation:, file: StringIO.new(intermediate_ca))).to be_valid
    end
    it "is invalid because it does not have a parent" do
      form = CertificateForm.new(name:, organisation:, file: StringIO.new(intermediate_ca))
      expect(form).to be_invalid
      expect(form.errors.of_kind?(:file, :no_parent)).to be true
    end
  end
end
