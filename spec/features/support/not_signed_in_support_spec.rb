require  'support/notifications_service'

describe 'user not signed in' do
  include_examples 'notifications service'

  context 'user goes to the support selection page' do
    before do
      visit new_help_path
    end

    it 'shows the user the not signed in support page' do
      expect(page).to have_content 'How can we help?'
    end

    it 'shows the user three options to choose from' do
      expect(page).to have_content 'I’m having trouble signing up'
      expect(page).to have_content 'Something’s wrong with my admin account'
      expect(page).to have_content 'Ask a question or leave feedback'
    end

    it "redirects the user to the 'Im having trouble signing up page'" do
      expect(page).to have_content 'I’m having trouble signing up'
    end

    it "redirects the user to the 'Somethings wrong with my admin account'" do
      expect(page).to have_content 'Something’s wrong with my admin account'
    end

    it "redirects the user to the 'Ask a question or leave feedback'" do
      expect(page).to have_content 'Ask a question or leave feedback'
    end

    context "allows the user to submit a support ticket request'" do
      before do
        visit new_help_path
      end

      it "when a user is 'having trouble signing up'" do
        choose('choice_id_1')
        click_button('Continue')
        expect(page).to have_content "I'm having trouble signing up"
        fill_in('name', :with => 'George')
        fill_in('email', :with => 'George@gov.uk')
        fill_in('organisation', :with => 'George Tech')
        fill_in('details', :with => "My laptop won't turn on... help please ")
        click_button('Submit')
        expect(page).to have_content 'Your support request has been submitted.'
      end

      it "when a user has 'something wrong with their admin account'" do
        choose('choice_id_2')
        click_button('Continue')
        expect(page).to have_content 'Something’s wrong with my admin account'
        fill_in('name', :with => 'George')
        fill_in('email', :with => 'George@gov.uk')
        fill_in('organisation', :with => 'George Tech')
        fill_in('details', :with => "I can't log into my admin account... help")
        click_button('Submit')
        expect(page).to have_content 'Your support request has been submitted.'
      end

      it "when a user has 'a question or wants to leave feedback'" do
        choose('choice_id_3')
        click_button('Continue')
        expect(page).to have_content 'Ask a question or leave feedback'
        fill_in('details', :with => 'I would like to leave feedback about how amazing GovWidi is!')
        fill_in('name', :with => 'George')
        fill_in('email', :with => 'George@gov.uk')

        click_button('Send')
        expect(page).to have_content 'Your support request has been submitted.'
      end

    end
  end
end
