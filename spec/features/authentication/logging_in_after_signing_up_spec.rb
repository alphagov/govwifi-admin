require 'support/notifications_service'
require 'support/confirmation_use_case'
require 'gateways/organisation_register_gateway'

describe 'logging in after signing up' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  let(:correct_password) { 'f1uffy-bu44ies' }

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

    sign_up_for_account(email: 'tom@gov.uk')
    update_user_details(password: correct_password)

    click_on 'Sign out'

    fill_in 'Email', with: 'tom@gov.uk'
    fill_in 'Password', with: password

    click_on 'Continue'
  end

  context 'with correct password' do
    let(:password) { correct_password }

    it 'signs me in' do
      expect(page).to have_content 'Sign out'
    end
  end

  context 'with incorrect password' do
    let(:password) { 'coarse' }

    it_behaves_like 'not signed in'

    it 'displays an error to the user' do
      expect(page).to have_content 'Invalid Email or password'
    end
  end
end
