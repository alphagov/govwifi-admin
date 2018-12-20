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
      visit signed_in_new_help_path
      fill_in 'Tell us about your issue', with: 'Help me barry.. im a duck too'
      fill_in 'Your email address', with: 'barry@gov.uk'
    end

    it 'submitting request explains a support request has been submitted' do
      click_on 'Send support request'
      expect(page).to have_content('Your support request has been submitted')
    end

    it 'redirects to the home page' do
      click_on 'Send support request'
      expect(page.current_path).to eq(root_path)
    end

    it 'submitting request sends an email to support' do
      expect {
        click_on 'Send support request'
      }.to change {
        SendHelpEmailSpy.support_emails_sent_count
      }.by(1)
    end
  end
end
