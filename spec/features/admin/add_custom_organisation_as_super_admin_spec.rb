describe 'adding a custom organisation' do
  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the organisations page' do
    before do
      sign_in_user admin_user
    end
  end
end
