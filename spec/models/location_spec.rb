describe Location do
  it { is_expected.to validate_presence_of(:address) }

  context 'associations' do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:ips) }
  end

  describe "#save" do
    subject { build(:location, organisation: organisation) }

    let(:organisation) { create(:organisation) }

    before { subject.save }

    it 'sets the radius_secret_key' do
      expect(subject.radius_secret_key).to be_present
    end
  end

  describe '#full_address' do
    before do
      subject.address = address
      subject.postcode = postcode
    end

    context 'with address' do
      let(:address) { "121 Fictional Street" }

      context 'and postcode' do
        let(:postcode) { "FI5 S67" }

        it "combines the two" do
          expect(subject.full_address).to eq("121 Fictional Street, FI5 S67")
        end
      end

      context 'but a blank postcode' do
        let(:postcode) { "" }

        it "only returns address" do
          expect(subject.full_address).to eq("121 Fictional Street")
        end
      end
    end
  end
end
