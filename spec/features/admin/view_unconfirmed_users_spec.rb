describe 'viewing all unconfirmed users' do
  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the manage users page' do
    before do
      sign_in_user admin_user
      visit admin_manage_users_path
    end

    it 'should show the user the manage users page' do
      expect(page).to_not have_content("Manage Users")
    end

  end
end
