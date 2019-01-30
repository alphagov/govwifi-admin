describe Gateways::OrganisationRegisterGateway do
  it 'fetches the organisations' do
    result = subject.fetch_organisations

    expect(result).to eq(
      [
        'UKTI Education',
        'Government Digital Service',
        'Academy for Social Justice Commissioning',
        'Administrative Justice and Tribunals Council'
      ]
    )
  end
end
