describe UseCases::Organisation::FetchOrganisationRegister do
  let(:gateway_spy) do
    instance_spy(
      Gateways::GovukOrganisationsRegisterGateway,
      government_orgs: [],
      local_authorities: [],
      custom_orgs: []
    )
  end

  context 'when calling the gateway' do
    before do
      described_class.new(organisations_gateway: gateway_spy).execute
    end

    it 'calls government_orgs ' do
      expect(gateway_spy).to have_received(:government_orgs)
    end

    it 'calls local_authorities' do
      expect(gateway_spy).to have_received(:local_authorities)
    end

    it 'calls custom_orgs' do
      expect(gateway_spy).to have_received(:custom_orgs)
    end
  end

  context 'with custom organisations' do
    let(:custom_orgs_list_gateway) do
      instance_double(
        Gateways::GovukOrganisationsRegisterGateway,
        government_orgs: [],
        local_authorities: [],
        custom_orgs: ['Custom Org 1', 'Custom Org 2', 'Custom Org 3']
      )
    end

    it 'returns the custom organisations' do
      response = described_class.new(organisations_gateway: custom_orgs_list_gateway).execute
      expect(response).to eq(['Custom Org 1', 'Custom Org 2', 'Custom Org 3'])
    end
  end

  context 'with government, local and custom organisations' do
    let(:use_case) do
      described_class.new(
        organisations_gateway: Gateways::GovukOrganisationsRegisterGateway.new
      )
    end
    let(:expected_response) do
      [
        "Gov Org 1", "Gov Org 2", "Gov Org 3", "Gov Org 4",
        "Local Auth 1", "Local Auth 2", "Local Auth 3", "Local Auth 4",
        'Custom Org 1', 'Custom Org 2'
      ]
    end

    before do
      CustomOrganisationName.create(name: 'Custom Org 1')
      CustomOrganisationName.create(name: 'Custom Org 2')
    end

    it 'returns the combined register of all orgs' do
      response = use_case.execute
      expect(response).to eq(expected_response)
    end
  end
end
