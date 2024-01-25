describe Certificate do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:valid_from) }
  it { is_expected.to validate_presence_of(:valid_to) }
  it { is_expected.to validate_presence_of(:serial_number) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to belong_to(:organisation) }

  context "when parsing a pem file" do
    subject(:certificate) { create(:certificate, :with_cert_file_and_org) }

    it "creates a valid certificate" do
      expect(certificate.name).to eq("mycert")
    end
  end
end
