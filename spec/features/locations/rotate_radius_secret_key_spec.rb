describe 'Rotate RADIUS secret key', type: :feature do
  context 'when a user has the correct permissions' do
    let(:user_1) { create(:user) }
    let!(:location_1) { create(:location, organisation: user_1.organisation) }
    let(:radius_key) { "ABC" }
    let(:set_secret_key) { location_1.update!(radius_secret_key: radius_key) }

    before do
      sign_in_user user_1
      visit ips_path
      click_on 'Rotate secret key'
      click_on 'Yes, rotate this RADIUS key'
    end

    it 'will tell the user they have successfully rotated their RADIUS key' do
      expect(page).to have_content('RADIUS secret key has been successfully rotated')
    end

    it 'will not show the old RADIUS secret key for that location' do
      expect(page).not_to have_content(radius_key)
    end
  end

  context 'when a user has the incorrect permissions' do
    let(:user_2) { create(:user) }
    let(:location_2) { create(:location, organisation: user_2.organisation) }

    before do
      user_2.permission.update!(can_manage_locations: false)
      sign_in_user user_2
      visit ips_path
    end

    it 'will not show the rotate secret key button' do
      expect(page).not_to have_content('Rotate secret key')
    end
  end
end
