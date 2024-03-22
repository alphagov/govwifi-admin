describe Certificate do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:valid_from) }
  it { is_expected.to validate_presence_of(:valid_to) }
  it { is_expected.to validate_presence_of(:serial_number) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to belong_to(:organisation) }

  context "when loading an intermediate certificate file" do
    subject(:certificate) { create(:certificate, :with_intermediate_cert_file_and_org) }

    it "creates a valid certificate" do
      expect(certificate.name).to eq "my_intermediate_cert"
      expect(certificate.is_root_cert).to be false
    end
  end

  context "when loading a root certificate file" do
    subject(:certificate) { create(:certificate, :with_root_cert_file_and_org) }

    it "creates a valid certificate" do
      expect(certificate.name).to eq "my_root_cert"
      expect(certificate.is_root_cert).to be true
    end
  end

  context "when loading a malformed certificate file" do
    subject(:certificate) { Certificate.new }

    it "raises an error" do
      expect { certificate.import_from_x509_file("spec/models/bad_cert.pem") }.to raise_error(RuntimeError, "Certificate file issue: PEM_read_bio_X509: bad base64 decode")
    end
  end

  context "when certificate.subject is identical to the certificate.issuer" do
    subject do
      cert = Certificate.new
      the_subject_value = "THE SUBJECT"
      cert.subject = the_subject_value
      cert.issuer = the_subject_value
      cert
    end

    it "is identified as a root certificate" do
      expect(subject.is_root_cert).to be true
    end
  end

  context "when has less than or equal to 31 days remaining validity" do
    subject do
      cert = Certificate.new
      cert.valid_to = Time.zone.now + 31.days
      cert
    end

    it "is identified as near expiry" do
      expect(subject.is_near_expiry).to be true
    end
  end

  context "when serial number is longer than 16 chars" do
    subject do
      cert = Certificate.new
      cert.serial_number = "1234560123456ABCX"
      cert
    end

    it "will return 13 characters when requesting truncated value" do
      expect(subject.get_truncated_serial_number).to eq "1234560123456"
    end
  end

  context "when attempting to add another certificate with the same name in the organisation" do
    subject do
      cert = Certificate.new
      cert.import_from_x509_file("spec/models/root_ca.pem")
      cert
    end

    let(:cert2) do
      create(:certificate, :with_intermediate_cert_file_and_org)
    end

    it "will cause an issue" do
      subject.organisation = cert2.organisation
      subject.name = cert2.name
      cert2.save!
      expect { subject.save! }.to raise_error(ActiveRecord::ActiveRecordError, "Validation failed: Certificate Name already taken")
    end
  end

  context "when attempting to a duplicate certificate in the organisation" do
    subject { create(:certificate, :with_intermediate_cert_file_and_org) }

    let(:cert2) do
      cert = create(:certificate, :with_intermediate_cert_file_and_org)
      cert.name = "a different name"
      cert
    end

    it "will cause an issue" do
      subject.organisation = cert2.organisation
      cert2.save!
      expect { subject.save! }.to raise_error(ActiveRecord::ActiveRecordError, "Validation failed: Identical Certificate already exists")
    end
  end
end
