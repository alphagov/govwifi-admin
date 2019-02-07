describe Gateways::GovukOrganisationsRegisterGateway do
  it 'fetches the organisations' do
    result = subject.government_orgs
    expect(result).to eq(
      [
        'Org 1',
        'Org 2',
        'Org 3',
        'Org 4'
      ]
    )
  end

  it 'fetches the local auths' do
    result = subject.local_authorities
    expect(result).to eq(
      [
        'Org 5',
        'Org 6',
        'Org 7',
        'Org 8'
      ]
    )
  end

context 'with custom oranisations' do

  before do
    CustomOrganisationName.create(name:'Org1')
    CustomOrganisationName.create(name:'Org2')
  end

  it 'fetches the custom orgs' do
    result = subject.custom_orgs
    expect(result).to eq(
      [
       'Org1',
       'Org2'
      ]
    )
    end
  end
end
