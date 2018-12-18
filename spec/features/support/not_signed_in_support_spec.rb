describe 'user not signed in' do
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

    end

    it "redirects the user to the 'Ask a question or leave feedback'" do

    end

  end
end
