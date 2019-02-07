describe Gateways::GovukOrganisationsRegisterGateway do
  it 'fetches the organisations' do
    result = subject.government_orgs
    expect(result).to eq(
      [
        'Gov Org 1',
        'Gov Org 2',
        'Gov Org 3',
        'Gov Org 4'
      ]
    )
  end

  it 'fetches the local auths' do
    result = subject.local_authorities
    expect(result).to eq(
      [
        'Local Auth 1',
        'Local Auth 2',
        'Local Auth 3',
        'Local Auth 4'
      ]
    )
  end

  context 'with custom organisations' do
    before do
      CustomOrganisationName.create(name: 'Custom Org 1')
      CustomOrganisationName.create(name: 'Custom Org 2')
    end

    it 'fetches the custom orgs' do
      result = subject.custom_orgs
      expect(result).to eq(
        [
        'Custom Org 1',
        'Custom Org 2'
        ]
      )
    end
  end
end
