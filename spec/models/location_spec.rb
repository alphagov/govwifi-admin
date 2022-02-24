describe Location do
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:postcode) }
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to have_many(:ips) }

  describe "#save" do
    subject(:location) { build(:location, organisation:) }

    let(:organisation) { create(:organisation) }

    before { location.save }

    it "sets the radius_secret_key" do
      expect(location.radius_secret_key).to be_present
    end
  end

  describe "#full_address" do
    subject(:location) { described_class.new }

    let(:address) { "121 Fictional Street" }
    let(:postcode) { "FI5 S67" }

    before do
      location.address = address
      location.postcode = postcode
    end

    it "combines an address and a postcode" do
      expect(location.full_address).to eq("121 Fictional Street, FI5 S67")
    end
  end

  # rubocop:disable Rails/SaveBang
  context "when validating postcode" do
    subject(:location) { described_class.new }

    it "errors when the postcode does not match the correct format" do
      location.update(postcode: "WHATEVER POSTCODE")
      expect(location.errors[:postcode]).to eq([
        "Postcode must be valid",
      ])
    end

    it "errors when the postcode is empty" do
      location.update(postcode: "")
      expect(location.errors[:postcode]).to eq([
        "Postcode can't be blank",
      ])
    end

    it "errors when the postcode is nil" do
      location.update(postcode: nil)
      expect(location.errors[:postcode]).to eq([
        "Postcode can't be blank",
      ])
    end
  end
  # rubocop:enable Rails/SaveBang

  context "when adding IPs with a mix of hash and strong parameters" do
    let(:location) do
      described_class.create(
        address: "6-8 HEMMING ST",
        postcode: "",
        organisation_id: create(:organisation).id,
        ips_attributes: ActionController::Parameters.new(
          "0" => ActionController::Parameters.new(address: "34.3.4.3"),
          "1" => ActionController::Parameters.new(address: "wrong"),
        ).permit!,
      )
    end

    it "does not pass validation" do
      expect(location).not_to be_valid
    end

    it "does not save when IPs are invalid" do
      expect(location.save).to be_falsey
    end
  end

  describe "#blank_ips" do
    subject(:location) { described_class.new }

    before do
      location.add_blank_ips(1)
    end

    it "creates the right number of blank ip addresses" do
      expect(location.blank_ips.count).to eq(1)
    end

    it "doesn’t persist the the blank ip addresses" do
      expect(location.blank_ips[0]).not_to be_persisted
    end
  end
end
