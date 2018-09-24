require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/support_email_use_case_spy'

describe 'contact us page' do
  let(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    end

  it 'says request sent after pressing submit' do
    visit('/help')
    
    fill_in "contact_number", with: "11111111112"
    fill_in "subject", with: "Subject"
    fill_in "details", with: "Details"

    click_on 'Submit'

    expect(page).to have_content('Your support request has been submitted')
  end
end
