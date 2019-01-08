describe 'Choosing how to filter' do
  before do
    sign_in_user create(:user)
    visit new_logs_search_path
  end

  context 'with no filter chosen' do
    before { click_on 'Go to search' }

    it_behaves_like 'errors in form'
  end

  xcontext 'with no locations' do
    it 'does not offer to go to search' do
      expect(page).to_not have_content('Go to search')
    end

    it 'offers to add locations first' do
      expect(page).to have_content('Add an IP address')
    end
  end
end
