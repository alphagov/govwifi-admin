describe 'Choosing how to filter' do
  before do
    sign_in_user create(:user)
    visit new_logs_search_path
  end

  context 'with no filter chosen' do
    before { click_on "Go to search" }

    it_behaves_like 'errors in form'
  end
end
