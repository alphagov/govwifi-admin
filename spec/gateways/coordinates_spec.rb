<<<<<<< HEAD
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
=======
describe Gateways::Coordinates, focus: true do
  subject(:postcode_coordinates_gateway) { described_class.new(postcodes: postcodes) }
>>>>>>> works

  context 'when given all valid postcodes' do
    let(:postcodes) { %w[OX49 5NU M32 0JG] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
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

      expect(result).to eq([
        { latitude: 51.656146, longitude: -1.069849 },
        { latitude: 53.455654, longitude: -2.302836 }
      ])
    end
  end

  context 'when given invalid postcodes' do
    context 'when given all invalid postcodes' do
      let(:postcodes) { %w[not_a_valid_postcode] }

      before do
        stub_request(:post, "http://api.postcodes.io/postcodes").
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

      it 'will return an empty list' do
        result = postcode_coordinates_gateway.fetch_coordinates
        expect(result).to eq([])
      end
    end

    context 'when given some invalid postcode' do
      let(:postcodes) { %w[not_a_valid_postcode] }

      before do
        stub_request(:post, "http://api.postcodes.io/postcodes").
        to_return(status: 200, body: {
            "status": 200,
            "result": [
                {
                    "query": "not_valid",
                    "result": nil
                }, {
                  "query": "M32 0JG",
                  "result": {
                    "latitude": 53.455654,
                    "longitude": -2.302836
                    }
                }
            ]
          }.to_json, headers: {})
      end

      it 'returns only the valid postcode longitude and latitude' do
        expect(postcode_coordinates_gateway.fetch_coordinates).to eq([
          { latitude: 53.455654, longitude: -2.302836 }
        ])
      end
    end
  end

  context 'when given many postcodes to look up' do
    let(:postcodes) { %w[HA72BL HA73BL HA74BL HA75BL] }

    before do
      stub_request(:post, "http://api.postcodes.io/postcodes").
      to_return(status: 200, body: {
        "status": 200,
        "result": [
            {
              "query": "HA7 2BL",
              "result": {
                "latitude": 51.656146,
                "longitude": -1.069849
                }
            },
            {
              "query": "HA7 3BL",
              "result": {
                "latitude": 52.455654,
                "longitude": -2.302836
                }
            },
            {
              "query": "HA7 4BL",
              "result": {
                "latitude": 53.656146,
                "longitude": -1.069849
                }
            },
            {
              "query": "HA7 5BL",
              "result": {
                "latitude": 54.656146,
                "longitude": -1.069849
                }
            }
          ]
        }.to_json, headers: {})
    end

<<<<<<< HEAD
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
<<<<<<< HEAD
      expect(result[:coordinates]).to eq([-0.316963, 51.604163])
>>>>>>> refac
=======
      expect(result[:coordinates]).to eq([
        [-1.069849, 51.656146],
        [-2.302836, 53.455654]
=======
      expect(result).to eq([
=======
      expect(result[:coordinates]).to eq([
>>>>>>> done
        [51.656146, -1.069849],
        [53.455654, -2.302836]
>>>>>>> plots on google maps
      ])
>>>>>>> gateway takes array of postcodes
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
    it 'batches them to prevent rate limiting' do
      postcode_coordinates_gateway.fetch_coordinates(batch_size: 2)

      assert_requested :post, "http://api.postcodes.io/postcodes", body: "postcodes[]=HA72BL&postcodes[]=HA73BL"
      assert_requested :post, "http://api.postcodes.io/postcodes", body: "postcodes[]=HA74BL&postcodes[]=HA75BL"
>>>>>>> works
    end
  end
end
