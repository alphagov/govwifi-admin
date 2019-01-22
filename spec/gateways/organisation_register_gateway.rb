require 'net/http'
require 'json'
require 'support/fetch_organisations'

describe Gateways::OrganisationRegisterGateway do
  include_examples 'organisations register'

  subject { described_class.new }

  it 'fetches the organisations' do
    result = subject.fetch_organisations

    expect(result).to eq(
      [
        'UKTI Education',
        'Ministry of Justice'
      ]
    )
  end
end
