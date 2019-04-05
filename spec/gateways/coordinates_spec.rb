describe Gateways::Coordinates, focus: true do
  subject(:postcode_coordinates_gateway) { described_class.new(postcodes: postcode) }

  context 'when given a valid postcode' do
    let(:postcode) { ['HA72BL', 'HA73BL'] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: {
        "status": 200,
        "result": [
            {
              "query": "OX49 5NU",
              "result": {
                  "longitude": -1.069849,
                  "latitude": 51.656146
                }
            },
            {
              "query": "M32 0JG",
              "result": {
                  "longitude": -2.302836,
                  "latitude": 53.455654
                }
            }
          ]
        }.to_json, headers: {})

    end

    it 'Converts the postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:coordinates]).to eq([
        [-1.069849, 51.656146],
        [-2.302836, 53.455654]
      ])
    end
  end

  context 'when given an invalid postcode' do
    let(:postcode) { 'not_a_valid_postcode' }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: {
          "status": 200,
          "result": [
              {
                  "query": "not_valid",
                  "result": nil
              }
          ]
        }.to_json, headers: {})
      end

    it 'will error' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:error]).to eq("Invalid postcode")
    end
  end
end
