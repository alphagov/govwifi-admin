require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/send_help_email_use_case_spy'
require'support/send_help_email_use_case'

describe 'contact us page' do
  include_examples 'notifications service'
  include_examples 'send help email use case spy'
  let(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    end

  it 'says request sent after pressing submit' do
    expect {
      visit('/help')
    
      fill_in "contact_number", with: "11111111112"
      fill_in "subject", with: "Subject"
      fill_in "details", with: "Details"
  
      click_on 'Submit'
    }.to change { SendHelpEmailSpy.support_emails_sent_count }.by(1)

    expect(page).to have_content('Your support request has been submitted')
  end
end
