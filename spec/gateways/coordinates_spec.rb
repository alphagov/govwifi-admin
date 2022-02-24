describe Gateways::Coordinates do
  subject(:postcode_coordinates_gateway) { described_class.new(postcodes:) }

  context "when all are valid postcodes" do
    let(:postcodes) { %w[OX49 5NU M32 0JG] }

    before do
      stub_request(:post, "https://api.postcodes.io/postcodes")
      .to_return(status: 200, body: {
        "status": 200,
        "result": [
          {
            "query": "OX49 5NU",
            "result": {
              "latitude": 51.656146,
              "longitude": -1.069849,
            },
          },
          {
            "query": "M32 0JG",
            "result": {
              "latitude": 53.455654,
              "longitude": -2.302836,
            },
          },
        ],
      }.to_json, headers: {})
    end

    it "Converts the postcode to long and latitude" do
      result = postcode_coordinates_gateway.fetch_coordinates

      expect(result).to eq([
        { latitude: 51.656146, longitude: -1.069849 },
        { latitude: 53.455654, longitude: -2.302836 },
      ])
    end
  end

  context "when given invalid postcodes" do
    context "when given all invalid postcodes" do
      let(:postcodes) { %w[not_a_valid_postcode] }

      before do
        stub_request(:post, "https://api.postcodes.io/postcodes")
        .to_return(status: 200, body: {
          "status": 200,
          "result": [
            {
              "query": "not_valid",
              "result": nil,
            },
          ],
        }.to_json, headers: {})
      end

      it "will return an empty list" do
        result = postcode_coordinates_gateway.fetch_coordinates
        expect(result).to eq([])
      end
    end

    context "when given some invalid postcode" do
      let(:postcodes) { %w[not_a_valid_postcode] }

      before do
        stub_request(:post, "https://api.postcodes.io/postcodes")
        .to_return(status: 200, body: {
          "status": 200,
          "result": [
            {
              "query": "not_valid",
              "result": nil,
            },
            {
              "query": "M32 0JG",
              "result": {
                "latitude": 53.455654,
                "longitude": -2.302836,
              },
            },
          ],
        }.to_json, headers: {})
      end

      it "returns only the valid postcode longitude and latitude" do
        expect(postcode_coordinates_gateway.fetch_coordinates).to eq([
          { latitude: 53.455654, longitude: -2.302836 },
        ])
      end
    end
  end

  context "when given many postcodes to look up" do
    let(:postcodes) { %w[HA72BL HA73BL HA74BL HA75BL] }

    before do
      stub_request(:post, "https://api.postcodes.io/postcodes")
      .to_return(status: 200, body: {
        "status": 200,
        "result": [
          {
            "query": "HA7 2BL",
            "result": {
              "latitude": 51.656146,
              "longitude": -1.069849,
            },
          },
          {
            "query": "HA7 3BL",
            "result": {
              "latitude": 52.455654,
              "longitude": -2.302836,
            },
          },
          {
            "query": "HA7 4BL",
            "result": {
              "latitude": 53.656146,
              "longitude": -1.069849,
            },
          },
          {
            "query": "HA7 5BL",
            "result": {
              "latitude": 54.656146,
              "longitude": -1.069849,
            },
          },
        ],
      }.to_json, headers: {})
    end

    it "batches them to prevent rate limiting" do
      postcode_coordinates_gateway.fetch_coordinates(batch_size: 2)

      assert_requested :post, "https://api.postcodes.io/postcodes", body: "postcodes%5B%5D=HA72BL&postcodes%5B%5D=HA73BL"
      assert_requested :post, "https://api.postcodes.io/postcodes", body: "postcodes%5B%5D=HA74BL&postcodes%5B%5D=HA75BL"
    end
  end
end
