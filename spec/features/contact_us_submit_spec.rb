require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/send_help_email_use_case_spy'
require 'support/send_help_email_use_case'

describe 'contact us page' do
  include_examples 'notifications service'
  include_examples 'send help email use case spy'

  let(:user) { create(:user) }

  context 'with support ticket details filled in' do
    before do
      sign_in_user user
      visit help_index_path
      fill_in 'contact_number', with: '11111111112'
      fill_in 'subject', with: 'Subject'
      fill_in 'details', with: 'Details'
    end

    it 'submitting request explains a support request has been submitted' do
      click_on 'Submit'
      expect(page).to have_content('Your support request has been submitted')
    end

    it 'redirects to the home page' do
      click_on 'Submit'
      expect(page.current_path).to eq(root_path)
    end

    it 'submitting request sends an email to support' do
      expect {
        click_on 'Submit'
      }.to change {
        SendHelpEmailSpy.support_emails_sent_count
      }.by(1)
    end
  end
end
