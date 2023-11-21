describe Certificate do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:valid_from) }
  it { is_expected.to validate_presence_of(:valid_to) }
  it { is_expected.to validate_presence_of(:serial_number) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to belong_to(:organisation) }

  context "when parsing a pem file" do
    let(:organisation) { create(:organisation) }
    subject(:certificate) { build(:certificate, organisation) }
    let(:certificate) { described_class.parse_and_create_from_file("spec/models/comodoCA.pem", organisation) }

    it "creates a valid certificate" do
      expect(certificate.name).to eq("Gov Org 1 cert 2B2E6EEAD975366C148A6EDBA37C8C07")
    end
  end
end
