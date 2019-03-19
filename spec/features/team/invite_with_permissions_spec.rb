describe 'Set user permissions on invite' do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user) }
  let(:invited_email) { 'invited@gov.uk' }
  let(:invited_user) { User.find_by(email: invited_email) }

  before do
    sign_in_user user
    visit new_user_invitation_path
    fill_in 'Email', with: invited_email
  end

  context 'when I set all the permissions' do
    it 'assigns all the permissions to the user' do
      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(true)
      expect(invited_user.permission.can_manage_locations?).to eq(true)
    end
  end

  context 'when I set only the .can_manage_team permission' do
    it 'assigns only that permission' do
      uncheck 'Manage locations'
      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(true)
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end

  context 'when I set no permissions' do
    it 'assigns no permissions' do
      uncheck 'Manage locations'
      uncheck 'Manage team'

      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(false)
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end
end
