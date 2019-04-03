describe 'Signing in as a super admin', type: :feature, focus: true do
  let(:user) { create(:user, :super_admin) }

  context 'when viewing the GovWifi map' do
    before do
      sign_in_user user
      visit admin_govwifi_map_index_path
    end

    it 'shows list of signed organisations on the home page' do
      expect(page).to have_content('GovWifi Map of Locations')
    end
  end
end
