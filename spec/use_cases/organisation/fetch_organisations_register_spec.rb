describe UseCases::Organisation::FetchOrganisationRegister do
  let(:gateway_spy) { spy(government_orgs: [], local_authorities: []) }

  it 'calls government_orgs on the gateway' do
    described_class.new(organisations_gateway: gateway_spy).execute
    expect(gateway_spy).to have_received(:government_orgs)
  end

  it 'calls local_authorities on the gateway' do
    described_class.new(organisations_gateway: gateway_spy).execute
    expect(gateway_spy).to have_received(:local_authorities)
  end
end
