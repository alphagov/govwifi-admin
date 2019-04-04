describe Gateways::Coordinates do
  subject(:postcode_coordinates_gateway) { described_class.new(postcode: postcode) }

  context 'when given a valid postcode' do
    let(:postcode) { 'HA72BL' }

    before do
      stub_request(:get, "http://api.postcodes.io/postcodes/HA72BL").
        to_return(status: 200,
          body: {
            status: 200,
            result: {
              longitude: -0.316963,
              latitude: 51.604163
            }
          }.to_json)
    end

    it 'Converts the postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:coordinates]).to eq([-0.316963, 51.604163])
    end
  end

  context 'when given an invalid postcode' do
    let(:postcode) { 'not_a_valid_postcode' }

    before do
      stub_request(:get, "http://api.postcodes.io/postcodes/not_a_valid_postcode").
        to_return(status: 404,
          body: {
            status: 404,
            result: {
              longitude: -0.316963,
              latitude: 51.604163
          }
        }.to_json)
    end

    it 'will error' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:error]).to eq("Invalid postcode")
    end
  end
end
