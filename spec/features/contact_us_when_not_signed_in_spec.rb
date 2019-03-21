describe 'Contact us when not signed in' do
  include_context 'with a mocked support tickets client'

  let(:email) { 'george@gov.uk' }
  let(:name) { 'George' }
  let(:details) { 'I have an issue' }

  before do
    ENV['ZENDESK_API_ENDPOINT'] = 'https://example-company.zendesk.com/api/v2/'
    ENV['ZENDESK_API_USER'] = 'zd-api-user@example-company.co.uk'
    ENV['ZENDESK_API_TOKEN'] = 'abcdefggfedcba'
    visit new_help_path
  end

  context 'navigating via links' do
    it 'shows the user the not signed in support page' do
      expect(page).to have_content 'How can we help?'
    end
  end

  context 'submits a support ticket' do
    it 'when having trouble signing up' do
      choose 'I\'m having trouble signing up'
      click_on('Continue')
      fill_in 'Your email address', with: email
      fill_in 'Tell us a bit more about your issue', with: details
      click_on('Submit')
      expect(page).to have_content 'Your support request has been submitted.'
    end

    it 'when something is wrong with their admin account' do
      choose 'Something\'s wrong with my admin account'
      click_on('Continue')
      expect(page).to have_content 'Something’s wrong with my admin account'
      fill_in 'Your email address', with: email
      fill_in 'Tell us a bit more about your issue', with: details
      click_on('Submit')
      expect(page).to have_content 'Your support request has been submitted.'
    end

    it 'when there is a question or feedback' do
      choose 'Ask a question or leave feedback'
      click_on('Continue')
      fill_in 'Your message', with: details
      fill_in 'Your email address', with: email
      click_on('Submit')
      expect(page).to have_content 'Your support request has been submitted.'
    end
  end

  context 'checks the email is actually sent' do
    it 'signing up email sent' do
      expect {
        visit signing_up_new_help_path
        fill_in 'Your email address', with: email
        fill_in 'Tell us a bit more about your issue', with: details
        click_on 'Submit'
      }.to change(support_tickets, :count).by(1)
    end

    it 'existing account email sent' do
      expect {
        visit signing_up_new_help_path
        fill_in 'Your email address', with: email
        fill_in 'Tell us a bit more about your issue', with: details
        click_on 'Submit'
      }.to change(support_tickets, :count).by(1)
    end

    it 'feedback email sent' do
      expect {
        visit feedback_new_help_path
        fill_in 'Your email address', with: email
        fill_in 'Your message', with: details
        click_on 'Submit'
      }.to change(support_tickets, :count).by(1)
    end

    it 'records the email' do
      visit signing_up_new_help_path
      fill_in 'Your email address', with: email
      fill_in 'Tell us a bit more about your issue', with: details
      click_on 'Submit'

      expect(support_tickets.last[:requester][:email])
        .to eq email
    end
  end

  context 'incorrectly filled out form' do
    before do
      visit signing_up_new_help_path
      fill_in 'Your email address', with: email
      fill_in 'Tell us a bit more about your issue', with: details
      expect { click_on('Submit') }.not_to change(support_tickets, :count)
    end

    context 'with blank details' do
      let(:details) { '' }

      it 'does not submit the form' do
        expect(page).to have_content 'Details can\'t be blank'
      end
    end

    context 'with blank email' do
      let(:email) { '' }

      it 'does not submit the form' do
        expect(page).to have_content 'Email can\'t be blank'
      end
    end

    context 'with incorrect email formats' do
      context 'without a subdomain' do
        let(:email) { 'test@' }

        it 'does not submit the form' do
          expect(page).to have_content 'Email is not a valid email address'
        end
      end

      context 'with random whitespace' do
        let(:email) { 'test@ gov .uk' }

        it 'does not submit the form' do
          expect(page).to have_content 'Email is not a valid email address'
        end
      end

      context 'without an @ symbol' do
        let(:email) { 'testgov.uk' }

        it 'does not submit the form' do
          expect(page).to have_content 'Email is not a valid email address'
        end
      end
    end
  end
end

context 'navigating directly to root/help path' do
  before { visit '/help' }

  it 'shows the user the not signed in support page' do
    expect(page).to have_content 'How can we help?'
  end
end

context 'navigating directly to signed-in help path' do
  before { visit '/help/new/signed_in' }

  it 'shows the user the not signed in support page' do
    expect(page).to have_content 'How can we help?'
  end
end
