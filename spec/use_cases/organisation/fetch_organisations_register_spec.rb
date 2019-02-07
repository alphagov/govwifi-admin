describe UseCases::Organisation::FetchOrganisationRegister do
  let(:gateway_spy) { spy(government_orgs: [], local_authorities: [], custom_orgs: []) }

  context 'On the gateway' do
    it 'calls government_orgs ' do
      described_class.new(organisations_gateway: gateway_spy).execute
      expect(gateway_spy).to have_received(:government_orgs)
    end

    it 'calls local_authorities' do
      described_class.new(organisations_gateway: gateway_spy).execute
      expect(gateway_spy).to have_received(:local_authorities)
    end

    it 'calls custom_orgs' do
      described_class.new(organisations_gateway: gateway_spy).execute
      expect(gateway_spy).to have_received(:custom_orgs)
    end
  end

  context 'with custom organisations' do
    let(:custom_orgs_list_gateway) { double(government_orgs: [], local_authorities: [], custom_orgs: ['Custom Org 1', 'Custom Org 2', 'Custom Org 3']) }

    it 'returns the custom organisations' do
      response = described_class.new(organisations_gateway: custom_orgs_list_gateway).execute
      expect(response).to eq(['Custom Org 1', 'Custom Org 2', 'Custom Org 3'])
    end
  end

  context 'with government, local and custom organisations' do
    before do
      CustomOrganisationName.create(name: 'Custom Org 1')
      CustomOrganisationName.create(name: 'Custom Org 2')
    end

    it 'returns the combined register of all orgs' do
      response = described_class.new(organisations_gateway: Gateways::GovukOrganisationsRegisterGateway.new).execute
      expect(response).to eq([
        "Gov Org 1", "Gov Org 2", "Gov Org 3", "Gov Org 4",
        "Local Auth 1", "Local Auth 2", "Local Auth 3", "Local Auth 4",
        'Custom Org 1', 'Custom Org 2'
      ])
    end
  end
end
