describe 'Tracking new organisations', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
    visit root_path
  end

  it 'displays an initial tag on the URL when logged in' do
    expect(page).to have_current_path('/setup_instructions/initial')
  end

  context 'when a user clicks on the setup sub-navigation link ' do
    before { click_on 'Setup' }

    it 'displays the initial tag on the URL' do
      expect(page).to have_current_path('/setup_instructions/initial')
    end
  end
end
