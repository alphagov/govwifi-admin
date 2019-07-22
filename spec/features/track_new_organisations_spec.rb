describe 'Tracking new organisations', type: :feature do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user, :with_organisation) }

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

  context 'when a user adds their first IP, then clicks setup link' do
    let!(:location) { create(:location, organisation: user.organisations.first) }
    let(:ip_address) { '120.0.129.150' }

    before do
      visit location_add_ips_path(location_id: location.id)
      fill_in 'location[ips_attributes][0][address]', with: ip_address
      click_on 'Add IP addresses'
      click_on 'Setup'
    end

    it 'does not display the initial tag on the URL' do
      expect(page).to have_current_path('/setup_instructions')
    end
  end
end
