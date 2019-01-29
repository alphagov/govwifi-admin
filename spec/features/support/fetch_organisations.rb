shared_examples 'organisations register' do
  before do
    stub_request(:get, "https://government-organisation.register.gov.uk/records.json?page-size=5000").
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
        }, "OT1099": {
          "index-entry-number":"1007",
          "entry-number":"1007",
          "entry-timestamp":"2018-10-18T09:50:55Z",
          "key":"OT1099",
          "item":[
            {
              "end-date":"2016-07-13",
              "website":"https://www.gov.uk/government/organisations/ukti-education",
              "name":"Org 1",
              "government-organisation":"OT1099"
            }
          ]
        }, "OT1068": {
          "index-entry-number":"1007",
          "entry-number":"1007",
          "entry-timestamp":"2018-10-18T09:50:55Z",
          "key":"OT1068",
          "item":[
            {
              "end-date":"2016-07-13",
              "website":"https://www.gov.uk/government/organisations/ukti-education",
              "name":"Org 2",
              "government-organisation":"OT1068"
            }
          ]
        }, "OT1069": {
          "index-entry-number":"1007",
          "entry-number":"1007",
          "entry-timestamp":"2018-10-18T09:50:55Z",
          "key":"OT1069",
          "item":[
            {
              "end-date":"2016-07-13",
              "website":"https://www.gov.uk/government/organisations/ukti-education",
              "name":"Org 3",
              "government-organisation":"OT1069"
            }
          ]
        }
      }'
    )
  end
end
