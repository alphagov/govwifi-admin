require 'features/support/sign_up_helpers'
require 'support/with_send_help_email_mocked'

describe 'contact us for support' do
  include_context 'with SendHelpEmail mocked'

  let(:user) { create(:user, :confirmed, :with_organisation) }

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
