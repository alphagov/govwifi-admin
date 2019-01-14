describe 'Choosing how to filter' do
  before do
    sign_in_user create(:user)
    visit new_logs_search_path
  end

  context 'with no filter chosen' do
    before { click_on 'Go to search' }

    it_behaves_like 'errors in form'
  end

  context 'hacking urls' do
    context 'to results link with no filter' do
      before { visit logs_path }

      it 'redirects me to choosing a filter' do
        expect(page).to have_content('How do you want to filter these logs?')
      end
    end

    context 'to location not in my organisation' do
      let(:other_location) { create(:location) }

      before { visit logs_path(location: other_location.id) }

      it 'redirects me to choosing a location' do
        expect(page).to have_content('Search logs by location')
      end
    end
  end
end
