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
      expect(create(:certificate, not_before: last_week)).to_not be_not_yet_valid
    end
  end

  describe "#has_parent?" do
    it "has a parent if the certificate is a root certificate" do
      root_ca = create(:certificate)
      expect(root_ca).to have_parent
    end
    it "returns false if the certificate does not have a parent" do
      intermediate_certificate = create(:certificate,
                                        issuing_key: OpenSSL::PKey::RSA.new(512),
                                        issuing_subject: root_subject)
      expect(intermediate_certificate).to_not have_parent
    end
    it "returns true for an intermediate with root" do
      create(:certificate, key:, subject: root_subject, organisation:)
      intermediate_ca = create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(intermediate_ca).to have_parent
    end
    it "returns false if the intermediate was signed by an unknown certificate" do
      create(:certificate, key: OpenSSL::PKey::RSA.new(512), subject: root_subject, organisation:)
      intermediate_ca = create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(intermediate_ca).to_not have_parent
    end
    it "returns true if the first intermediate is invalid and the second is valid" do
      create(:certificate, key:, issuing_key: OpenSSL::PKey::RSA.new(512), subject: root_subject, organisation:)
      create(:certificate, key:, subject: root_subject, organisation:)
      intermediate_ca = create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(intermediate_ca).to have_parent
    end
    it "does not care if the certificate is expired" do
      create(:certificate, key:, subject: root_subject, not_after: last_week, organisation:)
      intermediate_ca = create(:certificate,
                               issuing_key: key,
                               not_after: last_week,
                               issuing_subject: root_subject,
                               organisation:)
      expect(intermediate_ca).to have_parent
    end
    it "returns false if the certificate is in a different organisation than the parent" do
      organisation_1 = create(:organisation)
      organisation_2 = create(:organisation)
      create(:certificate, key:, subject: root_subject, organisation: organisation_1)
      intermediate_ca = create(:certificate,
                               issuing_key: key,
                               issuing_subject: root_subject,
                               organisation: organisation_2)
      expect(intermediate_ca).to_not have_parent
    end
  end

  describe "#has_child?" do
    it "a single root has no child" do
      root_ca = create(:certificate)
      expect(root_ca).to_not have_child
    end
    it "has a child" do
      root_ca = create(:certificate, key:, subject: root_subject, organisation:)
      create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(root_ca).to have_child
    end
    it "ignores children outside the organisation" do
      organisation_1 = create(:organisation)
      organisation_2 = create(:organisation)
      root_ca = create(:certificate, key:, subject: root_subject, organisation: organisation_1)
      create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation: organisation_2)
      expect(root_ca).to_not have_child
    end
    it "ignores children that are signed by a different key" do
      root_ca = create(:certificate, key:, subject: root_subject, organisation:)
      create(:certificate, issuing_key: OpenSSL::PKey::RSA.new(512), issuing_subject: root_subject, organisation:)
      expect(root_ca).to_not have_child
    end
    it "handles multiple children, including those signed by a different key" do
      root_ca = create(:certificate, key:, subject: root_subject, organisation:)
      create(:certificate, issuing_key: OpenSSL::PKey::RSA.new(512), issuing_subject: root_subject, organisation:)
      create(:certificate, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(root_ca).to have_child
    end
    it "does not care if certificates have expired" do
      root_ca = create(:certificate, key:, subject: root_subject, not_after: last_week, organisation:)
      create(:certificate, issuing_key: key, not_after: last_week, issuing_subject: root_subject, organisation:)
      expect(root_ca).to have_child
    end
  end

  describe "EC encryption" do
    let(:key) { OpenSSL::PKey::EC.generate("prime256v1") }
    let(:child_key) { OpenSSL::PKey::EC.generate("prime256v1") }

    it "has a child" do
      root_ca = create(:certificate, key:, subject: root_subject, organisation:)
      create(:certificate,
             key: child_key,
             issuing_key: key,
             issuing_subject: root_subject,
             organisation:)
      expect(root_ca).to have_child
    end

    it "has a parent" do
      create(:certificate, key:, subject: root_subject, organisation:)
      intermediate_ca = create(:certificate, key: child_key, issuing_key: key, issuing_subject: root_subject, organisation:)
      expect(intermediate_ca).to have_parent
    end
  end
end
