describe Gateways::PostcodeConversionGateway do
  subject(:postcode_coordinates_gateway) { described_class.new(postcode: postcode) }

  context 'when converting a valid postcode to long and lat' do
    let(:postcode) { 'HA72BL' }

    it 'Converts a given postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result).to eq([-0.316963, 51.604163])
    end
  end

  context 'when converting an invalid postcode to long and lat' do
    let(:postcode) { 'not a valid postcode' }

    it 'will error with an invalid postcode' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result).to eq('Invalid postcode')
    end
  end
end
