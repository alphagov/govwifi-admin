describe Ip do
  it { should belong_to(:location) }

  context "validations" do
    it { should validate_presence_of(:address) }
    it { should validate_uniqueness_of(:address) }

    context "address" do
      let(:location) { create(:location, organisation: create(:organisation)) }

      context "when invalid" do
        let!(:ip) { Ip.create(address: "invalidIP", location: location) }

        it "does not save when address is an invalid IP" do
          expect(Ip.count).to eq(0)
          expect(ip.errors.full_messages).to eq([
            "Address 'invalidIP' is not valid"
          ])
        end

        it 'prevents 0.0.0.0' do
          ip = Ip.create(address: '0.0.0.0', location: location)
          expect(ip.errors.full_messages).to eq([
            "Address '0.0.0.0' is not valid"
          ])
        end
      end

      context "when valid" do
        let!(:ip) { Ip.create(address: "10.0.0.1", location: location) }

        it "saves when address is a valid IP" do
          expect(Ip.count).to eq(1)
          expect(ip.errors.full_messages).to eq([])
        end
      end
    end
  end

  context '#available' do
    context 'with a created date at 2am today' do
      before { subject.created_at = Date.today.beginning_of_day + 2.hour }

      it { is_expected.to_not be_available }
    end

    context 'with a created date before 2am today' do
      before { subject.created_at = Date.today.beginning_of_day + 119.minutes }

      it { is_expected.to be_available }
    end
  end
end
