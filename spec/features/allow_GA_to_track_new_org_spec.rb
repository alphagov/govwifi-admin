describe 'Allowing GA to track an organisation with no IPs via URL paths', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
    visit root_path
  end

  it 'displays an inital tag on the URL when logged in' do
    expect(page).to have_current_path('/setup_instructions/initial')
  end

  context 'when visiting the setup instruction page at any time' do
    before { click_on 'Setup' }

    it 'displays an inital tag on the URL' do
      expect(page).to have_current_path('/setup_instructions/initial')
    end
  end
end
