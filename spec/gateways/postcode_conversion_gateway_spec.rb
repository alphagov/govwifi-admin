describe Gateways::PostcodeConversionGateway do
  subject(:postcode_conversion) { described_class.new }

  it 'Converts a given postcode to long and latitude' do
    result = postcode_conversion.convert_postcode_to_long_and_lat('HA7 2BL')
    expect(result).to eq([-0.316963, 51.604163])
  end
end
