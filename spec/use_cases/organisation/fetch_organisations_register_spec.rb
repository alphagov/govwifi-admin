describe UseCases::Organisation::FetchOrganisationRegister do
  let(:organisation_register_gateway) { double(fetch_organisations: nil) }

  it 'calls fetch_organisations on the gateway' do
    described_class.new(organisations_gateway: organisation_register_gateway).execute
    expect(organisation_register_gateway).to have_received(:fetch_organisations)
  end
end
