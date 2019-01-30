describe Gateways::OrganisationRegisterGateway do
  it 'fetches the organisations' do
    result = subject.fetch_organisations

    expect(result).to eq(
      [
        'Org 1',
        'Org 2',
        'Org 3',
        'Org 4'
      ]
    )
  end
end
