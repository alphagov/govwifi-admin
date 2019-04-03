describe 'Signing in as a super admin', type: :feature do
  let(:user) { create(:user, :super_admin) }

  context 'when viewing the GovWifi map' do
    before do
      sign_in_user user
      visit admin_govwifi_map_index_path
    end
  end
end
