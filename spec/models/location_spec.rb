describe Location do
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:postcode) }

  context 'with associations' do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:ips) }
  end

  describe '#save' do
    subject(:location) { build(:location, organisation: organisation) }

    let(:organisation) { create(:organisation) }

    before { location.save }

    it 'sets the radius_secret_key' do
      expect(location.radius_secret_key).to be_present
    end
  end

  describe '#full_address' do
    subject(:location) { described_class.new }

    before do
      location.address = address
      location.postcode = postcode
    end

    context 'with address and postcode' do
      let(:address) { '121 Fictional Street' }
      let(:postcode) { 'FI5 S67' }

      it 'combines the two' do
        expect(location.full_address).to eq('121 Fictional Street, FI5 S67')
      end
    end
  end

  describe 'Entering a postcode' do
    subject(:location) { described_class.new }

    context 'when in the incorrect format' do
      it 'errors as the postcode does not match the correct format' do
        location.postcode = 'WHATEVER POSTCODE'
        expect(location).not_to be_valid
      end

      it 'errors as the postcode is empty' do
        location.postcode = ''
        expect(location).not_to be_valid
      end

      it 'errors as the postcode is nil' do
        location.postcode = nil
        expect(location).not_to be_valid
      end
    end
  end

  describe 'saving invalid IPs with mix of hash and strong parameters' do
    let(:location) {
      described_class.create(
        address: '6-8 HEMMING ST',
        postcode: '',
        organisation_id: create(:organisation).id,
        ips_attributes: ActionController::Parameters.new(
          "0" => ActionController::Parameters.new(address: '34.3.4.3'),
          "1" => ActionController::Parameters.new(address: 'wrong')
        ).permit!
      )
    }

    it 'does not save invalid IPs' do
      expect(location.save).to be_falsey
    end

    it 'is invalid' do
      expect(location).not_to be_valid
    end
  end
end
