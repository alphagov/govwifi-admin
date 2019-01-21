require 'spec_helper'
require 'net/http'
require 'json'

describe Gateways::OrganisationRegisterGateway do
  subject { described_class.new }

  before do
    stub_request(:get, "https://government-organisation.register.gov.uk/records.json?page-size=5000").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        status: 200,
      body: '{
        "OT1067": {
          "index-entry-number":"1007",
          "entry-number":"1007",
          "entry-timestamp":"2018-10-18T09:50:55Z",
          "key":"OT1067",
          "item":[
            {
              "end-date":"2016-07-13",
              "website":"https://www.gov.uk/government/organisations/ukti-education",
              "name":"UKTI Education",
              "government-organisation":"OT1067"
            }
          ]
        },
        "OT7837":{
          "index-entry-number":"2332",
          "entry-number":"2332",
          "entry-timestamp":"2018-10-18T09:50:55Z",
          "key":"OT7837",
          "item":[
            {
              "end-date":"2016-07-13",
              "website":"https://www.gov.uk/government/organisations/ministry-of-justice",
              "name":"Ministry of Justice",
              "government-organisation":"OT7837"
            }
          ]
        }
      }',
        headers: {})
  end

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
