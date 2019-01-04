describe 'Contact us when signed in' do
  include_context 'with a mocked notifications client'

  let(:organisation) { create :organisation }

  before do
    sign_in_user create(:user, organisation: organisation)
    visit signed_in_new_help_path
  end

  context 'with details filled in' do
    before do
      fill_in 'Tell us about your issue', with: 'Help me barry.. im a duck too'
      fill_in 'Your email address', with: 'barry@gov.uk'
      click_on 'Send support request'
    end

    it 'shows a success message' do
      expect(page).to have_content('Your support request has been submitted')
    end

    it 'redirects to the home page' do
      expect(page.current_path).to eq(setup_index_path)
    end

    it 'sends a help email' do
      expect(notifications.count).to eq(1)
      expect(last_notification_type).to eq 'help'
    end

    it 'records the organisation' do
      expect(last_notification_personalisation[:organisation])
        .to eq organisation.name
    end
  end

  context 'with no details filled' do
    before { click_on 'Send support request' }

    it_behaves_like 'errors in form'

    it 'sends no emails' do
      expect(notifications).to be_empty
    end
  end
end
