<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
describe Gateways::Coordinates do
<<<<<<< HEAD
<<<<<<< HEAD
=======
describe Gateways::Coordinates, focus: true do
>>>>>>> GETS COORDINATES
=======
describe Gateways::Coordinates do
>>>>>>> more stuff
=======
describe Gateways::Coordinates do
>>>>>>> plots on google maps
  subject(:postcode_coordinates_gateway) { described_class.new(postcodes: postcode) }

  context 'when given a valid postcode' do
    let(:postcode) { %w[HA72BL HA73BL] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept' => '*/*',
       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent' => 'Ruby'
       }
       ).
      to_return(status: 200, body: {
        "status": 200,
        "result": [
            {
              "query": "OX49 5NU",
              "result": {
                "latitude": 51.656146,
                "longitude": -1.069849
                }
            },
            {
              "query": "M32 0JG",
              "result": {
                "latitude": 53.455654,
                "longitude": -2.302836
                }
            }
          ]
        }.to_json, headers: {})
    end

    it 'Converts the postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
      expect(result[:coordinates]).to eq([
        [51.656146, -1.069849],
        [53.455654, -2.302836]
      ])
    end
  end

  context 'when given an invalid postcode' do
    let(:postcode) { %w[not_a_valid_postcode] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept' => '*/*',
       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent' => 'Ruby'
        }
        ).
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
=======
  subject(:postcode_coordinates_gateway) { described_class.new(postcode: postcode) }
=======
=======
describe Gateways::Coordinates, focus: true do
>>>>>>> validate invalid postcodes
  subject(:postcode_coordinates_gateway) { described_class.new(postcodes: postcode) }
>>>>>>> gateway takes array of postcodes

  context 'when given a valid postcode' do
    let(:postcode) { %w[HA72BL HA73BL] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept' => '*/*',
       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent' => 'Ruby'
       }
       ).
      to_return(status: 200, body: {
        "status": 200,
        "result": [
            {
              "query": "OX49 5NU",
              "result": {
                "latitude": 51.656146,
                "longitude": -1.069849
                }
            },
            {
              "query": "M32 0JG",
              "result": {
                "latitude": 53.455654,
                "longitude": -2.302836
                }
            }
          ]
        }.to_json, headers: {})
    end

    it 'Converts the postcode to long and latitude' do
      result = postcode_coordinates_gateway.fetch_coordinates
<<<<<<< HEAD
<<<<<<< HEAD
      expect(result[:coordinates]).to eq([-0.316963, 51.604163])
>>>>>>> refac
=======
      expect(result[:coordinates]).to eq([
        [-1.069849, 51.656146],
        [-2.302836, 53.455654]
=======
      expect(result).to eq([
        [51.656146, -1.069849],
        [53.455654, -2.302836]
>>>>>>> plots on google maps
      ])
>>>>>>> gateway takes array of postcodes
    end
  end

  context 'when given an invalid postcode' do
    let(:postcode) { 'not_a_valid_postcode' }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      with(
        headers: {
       'Accept' => '*/*',
       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'User-Agent' => 'Ruby'
        }
        ).
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
