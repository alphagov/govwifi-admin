describe Location, focus: true do
  it { is_expected.to validate_presence_of(:address) }

  context 'associations' do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:ips) }
  end

  describe '#save' do
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
      let(:address) { '121 Fictional Street' }

      context 'and postcode' do
        let(:postcode) { 'FI5 S67' }

        it 'combines the two' do
          expect(subject.full_address).to eq('121 Fictional Street, FI5 S67')
        end
      end

      context 'but a blank postcode' do
        let(:postcode) { nil }

        it 'will error as postcode is nil' do
          expect(subject.full_address).to eq('121 Fictional Street')
        end
      end
    end
  end

  describe 'saving invalid IPs with mix of hash and strong parameters' do
    it 'does not save invalid IPs' do
      location = Location.create(
        address: '6-8 HEMMING ST',
        postcode: '',
        organisation_id: create(:organisation).id,
        ips_attributes: ActionController::Parameters.new(
          "0" => ActionController::Parameters.new(address: '34.3.4.3'),
          "1" => ActionController::Parameters.new(address: 'wrong')
        ).permit!
      )

      expect(location.save).to be_falsey
      expect(location).to_not be_valid
    end
  end
end
