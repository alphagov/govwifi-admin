describe Certificate do
  let(:next_week) { Time.zone.now.days_since(7) }
  let(:last_week) { Time.zone.now.days_ago(7) }
  let(:key) { OpenSSL::PKey::RSA.new(512) }
  let(:root_subject) { "/CN=root" }
  let(:organisation) { create(:organisation) }

  it "is valid" do
    expect(create(:certificate, key:, subject: root_subject)).to be_valid
    expect(create(:certificate, issuing_subject: root_subject, issuing_key: key)).to be_valid
  end

  describe "#root_cert?" do
    it "is not a root certificate" do
      create(:certificate, key:, subject: root_subject)
      expect(create(:certificate, issuing_subject: root_subject, issuing_key: key)).to_not be_root_cert
    end

    it "is a root certificate" do
      expect(create(:certificate, key:, subject: root_subject)).to be_root_cert
    end
  end

  describe "#has_expired" do
    it "is expired" do
      expect(create(:certificate, not_after: last_week)).to be_expired
    end
    it "is not expired" do
      expect(create(:certificate, not_after: next_week)).to_not be_expired
    end
  end

  describe "#nearly_expired?" do
    it "is nearly expired" do
      expect(create(:certificate, not_after: next_week).nearly_expired?(14)).to be true
    end
    it "is not nearly expired" do
      expect(create(:certificate, not_after: next_week).nearly_expired?(3)).to be false
    end
  end

  describe "#not_yet_valid?" do
    it "is not yet valid" do
      expect(create(:certificate, not_before: next_week)).to be_not_yet_valid
    end
    it "is already valid" do
      expect(certificate).to_not be_not_yet_valid
      expect(create(:certificate, not_before: last_week)).to_not be_not_yet_valid
    end
  end
    end
  end
end
