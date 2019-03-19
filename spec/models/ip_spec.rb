describe Ip do
  it { is_expected.to belong_to(:location) }

  context "validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_uniqueness_of(:address) }

    context "address" do
      let(:location) { create(:location, organisation: create(:organisation)) }

      context "when invalid" do
        let!(:ip) { described_class.create(address: "invalidIP", location: location) }

        it "does not save when address is an invalid IP" do
          expect(described_class.count).to eq(0)
          expect(ip.errors.full_messages).to eq([
            "Address 'invalidIP' is not valid"
          ])
        end

        it 'prevents 0.0.0.0' do
          ip = described_class.create(address: '0.0.0.0', location: location)
          expect(ip.errors.full_messages).to eq([
            "Address '0.0.0.0' is not valid"
          ])
        end
      end

      context "when valid" do
        let!(:ip) { described_class.create(address: "141.0.149.130", location: location) }

        it "saves when address is a valid IP" do
          expect(described_class.count).to eq(1)
          expect(ip.errors.full_messages).to eq([])
        end
      end
    end
  end

  context '#available' do
    context 'with a created date at 12am today' do
      before { subject.created_at = Date.today.beginning_of_day }

      it { is_expected.not_to be_available }
    end

    context 'with a created date before 12am today' do
      before { subject.created_at = Date.today.beginning_of_day - 1.second }

      it { is_expected.to be_available }
    end
  end
end
