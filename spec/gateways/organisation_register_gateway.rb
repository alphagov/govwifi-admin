describe Gateways::OrganisationRegisterGateway do

  subject { described_class.new }

  it 'fetches the organisations' do
    result = subject.fetch_organisations

    expect(result).to eq(
      [
        'UKTI Education',
        'Ministry of Justice'
      ]
    )
  end
end
