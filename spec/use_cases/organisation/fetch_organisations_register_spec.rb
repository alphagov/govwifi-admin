describe UseCases::Organisation::FetchOrganisationRegister do
  let(:gateway_spy) { spy(government_orgs: [], local_authorities: [], custom_orgs: []) }

  it 'calls government_orgs on the gateway' do
    described_class.new(organisations_gateway: gateway_spy).execute
    expect(gateway_spy).to have_received(:government_orgs)
  end

  it 'calls local_authorities on the gateway' do
    described_class.new(organisations_gateway: gateway_spy).execute
    expect(gateway_spy).to have_received(:local_authorities)
  end

  it 'calls custom_orgs on the gateway' do
    described_class.new(organisations_gateway: gateway_spy).execute
    expect(gateway_spy).to have_received(:custom_orgs)
  end

  context 'get the custom orgs' do
    let(:custom_orgs_list_gateway) { double(government_orgs: [], local_authorities: [], custom_orgs: ['Custom Org 1', 'Custom Org 2', 'Custom Org 3']) }

    it 'returns the custom orgs' do
      response = described_class.new(organisations_gateway: custom_orgs_list_gateway).execute
      expect(response).to eq(['Custom Org 1', 'Custom Org 2', 'Custom Org 3'])
    end
  end

  context 'appends the custom orgs to the govuk registers' do
    let(:custom_orgs_list_gateway) { double(government_orgs: ['Custom Org 1', 'Custom Org 2', 'Custom Org 3'],
      local_authorities: ['Custom Org 4', 'Custom Org 5', 'Custom Org 6'],
      custom_orgs: ['Custom Org 7', 'Custom Org 8', 'Custom Org 9']) }

    it 'returns the combined list of orgs' do
      response = described_class.new(organisations_gateway: custom_orgs_list_gateway).execute
      expect(response).to eq([
        'Custom Org 1', 'Custom Org 2', 'Custom Org 3',
        'Custom Org 4', 'Custom Org 5', 'Custom Org 6',
        'Custom Org 7', 'Custom Org 8', 'Custom Org 9', ])
    end
  end
end
