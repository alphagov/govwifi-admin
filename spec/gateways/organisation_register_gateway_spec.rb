describe Gateways::OrganisationRegisterGateway do
  it 'fetches the organisations' do
    result = subject.fetch_organisations

    expect(result).to eq(
      [
        'Org 1',
        'Org 2',
        'Org 3',
        'Org 4',
        'Org 5',
        'Org 6',
        'Org 7',
        'Org 8'
      ]
    )
  end
end
