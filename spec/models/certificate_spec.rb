describe Certificate do
  let(:name) { "mycert" }
  let(:content) { "A certificate" }
  let(:fingerprint) { "ABC123" }
  let(:certificate_subject) { "/CN=RootCA" }
  let(:issuer) { "/CN=RootCA" }
  let(:not_before) { Time.zone.now }
  let(:not_after) { Time.zone.now.days_since(4 * 7) }
  let(:serial) { "12345" }

  subject(:certificate) do
    build(:certificate, :with_organisation,
          name:,
          content:,
          fingerprint:,
          subject: certificate_subject,
          issuer:,
          not_before:,
          not_after:,
          serial:)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_presence_of(:fingerprint) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:issuer) }
  it { is_expected.to validate_presence_of(:not_before) }
  it { is_expected.to validate_presence_of(:not_after) }
  it { is_expected.to validate_presence_of(:serial) }
  it { is_expected.to belong_to(:organisation) }

  it "is valid" do
    expect(certificate).to be_valid
  end

  context "when loading an intermediate certificate file" do
    let(:certificate_subject) { "/CN=intermediate" }
    it "is not a root certificate" do
      expect(certificate).to_not be_root_cert
    end
  end

  context "when loading a root certificate file" do
    it "is a root certificate" do
      expect(certificate).to be_root_cert
    end
  end

  describe "#has_expired" do
    context "expired" do
      let(:not_after) { Time.zone.now.days_ago(7) }
      it "is expired" do
        expect(certificate).to be_expired
      end
    end
    context "not expired" do
      it "is not expired" do
        expect(certificate).to_not be_expired
      end
    end
  end

  describe "#nearly_expired?" do
    let(:not_after) { Time.zone.now.days_since(7) }
    it "is nearly expired" do
      expect(certificate.nearly_expired?(14)).to be true
    end
    it "is not nearly expired" do
      expect(certificate.nearly_expired?(3)).to be false
    end
  end

  describe "#not_yet_valid?" do
    context "not yet valid" do
      let(:not_before) { Time.zone.now.days_since(7) }
      it "is not yet valid" do
        expect(certificate).to be_not_yet_valid
      end
    end
    it "is already valid" do
      expect(certificate).to_not be_not_yet_valid
    end
  end
end
