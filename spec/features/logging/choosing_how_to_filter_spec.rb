describe 'Choosing how to filter', type: :feature do
  before do
    sign_in_user create(:user)
    visit new_logs_search_path
  end

  context 'with no filter chosen' do
    before { click_on 'Go to search' }

    it_behaves_like 'errors in form'
  end

  context 'when changing URL parameters' do
    context 'with no filter on results link' do
      before { visit logs_path }

      it 'redirects me to choosing a filter' do
        expect(page).to have_content('How do you want to filter these logs?')
      end
    end

    context "with a location not in in the user's organisation" do
      let(:other_location) { create(:location) }

      it 'does not find the location' do
        expect {
          visit logs_path(location: other_location.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
