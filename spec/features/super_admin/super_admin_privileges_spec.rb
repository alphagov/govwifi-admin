describe 'Managing super admin privileges' do
  let(:user) { create(:user) }

  before do
    sign_in_user create(:user, super_admin: true)
    visit admin_organisation_path(user.organisation)
  end

  context 'when granting super admin privileges' do
    before do
      user.update(super_admin: false)
    end

    it 'displays the make super admin link' do
      expect(page).to have_button("grant super admin")
    end
  end

  context 'when revoking super admin privileges' do
    before do
      user.update(super_admin: true)
    end

    it 'displays the revoke super admin link' do
      expect(page).to have_button("revoke super admin")
    end
  end
end
