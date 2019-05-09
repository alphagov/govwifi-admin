describe 'Rotate RADIUS secret key', type: :feature, focus: true do
  include_context 'with a mocked notifications client'

  context 'if a user has the corret permissions' do
    let(:user_1) { create(:user) }
    let!(:location_1) { create(:location, organisation: user_1.organisation) }

    before do
      sign_in_user user_1
      visit ips_path
    end

    it 'will ask the user are you sure you want to rotate this RADIUS secret key?' do
      click_on 'Rotate secret key'
      expect(page).to have_content('Are you sure you want to rotate this RADIUS secret key?')
    end
  end

  context 'if a user has the incorrect permissions' do
    let(:user_2) { create(:user) }
    let!(:location_2) { create(:location, organisation: user_2.organisation) }
    let!(:change_permissions) { user_2.permission.update!(can_manage_locations: false)}

    before do
      sign_in_user user_2
      visit ips_path
    end

    it 'will not show the rotate secret key button' do
      expect(page).to_not have_content('Rotate secret key')
    end
  end
end
