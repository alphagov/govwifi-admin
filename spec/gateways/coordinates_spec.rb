describe Gateways::Coordinates do
  subject(:postcode_coordinates_gateway) { described_class.new(postcode: postcode) }

  before do
    stub_request(:get, "http://api.postcodes.io/postcodes/HA72BL").
    to_return(status: 200, body: File.read("#{Rails.root}/spec/fixtures/postcode_conversion_payload.json"))
  end

  context 'when converting a valid postcode to long and lat' do
    let(:postcode) { 'HA72BL' }

    it 'Converts a given postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:coordinates]).to eq([-0.316963, 51.604163])
    end
  end
end
