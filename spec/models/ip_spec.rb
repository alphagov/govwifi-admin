describe Ip do
  it { should belong_to(:location) }

  context "validations" do
    it { should validate_presence_of(:address) }

    context "address" do
      let(:location) { create(:organisation).locations.first }

      context "when invalid" do
        let!(:ip) { Ip.create(address: "invalidIP", location: location) }

        it "does not save when address is an invalid IP" do
          expect(Ip.count).to eq(0)
          expect(ip.errors.full_messages).to eq([
            "Address must be a valid IPv4 address (without subnet)"
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
end
