describe UseCases::Administrator::ConvertPostcode do
  let(:gateway_spy) { spy(postcode: nil) }
  let(:postcode) { ("HA72BL") }

  context 'On the gateway' do
    it 'calls fetch_coordinates ' do
      described_class.new(convert_postcode_gateway: gateway_spy, postcode: postcode).execute
      expect(gateway_spy).to have_received(:fetch_coordinates)
    end
  end

  context 'with a postcode' do
    let(:postcode_gateway) { double(postcode: postcode) }

    it 'returns the coordinates' do
      response = described_class.new(convert_postcode_gateway: postcode_gateway, postcode: postcode).execute('HA72BL')
      expect(response).to eq('HA72BL')
    end
  end
end
