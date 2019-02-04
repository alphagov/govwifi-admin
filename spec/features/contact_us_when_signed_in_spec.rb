describe 'Contact us when signed in' do
  include_context 'with a mocked support tickets client'

  let(:organisation) { create :organisation }
  let(:user) { create(:user, organisation: organisation) }

  before do
    sign_in_user user
    visit signed_in_new_help_path
    ENV['ZENDESK_API_ENDPOINT'] = 'https://example-company.zendesk.com/api/v2/'
    ENV['ZENDESK_API_USER'] = 'zd-api-user@example-company.co.uk'
    ENV['ZENDESK_API_TOKEN'] = 'abcdefggfedcba'
  end

  context 'with details filled in' do
    before do
      fill_in 'Tell us about your issue', with: 'Help me, Barry!'
      click_on 'Send support request'
    end

    it 'shows a success message' do
      expect(page).to have_content('Your support request has been submitted')
    end

    it 'redirects to the home page' do
      expect(page.current_path).to eq(setup_instructions_path)
    end

    it 'opens a support ticket' do
      expect(support_tickets.count).to eq 1
    end

    it 'some details of support ticket?' do
      expect(support_tickets.last[:requester][:email]).to eq(user.email)
      expect(support_tickets.last[:comment][:value]).to eq(
        'Help me, Barry!'
      )
    end
  end

  context 'with no details filled' do
    before { click_on 'Send support request' }

    it_behaves_like 'errors in form'

    it 'opens no support tickets' do
      expect(support_tickets).to be_empty
    end
  end

  context 'from root/help path' do
    before { visit '/help' }

    it 'shows the user the not signed in support page' do
      expect(page).to have_content 'How can we help?'
    end
  end
end
