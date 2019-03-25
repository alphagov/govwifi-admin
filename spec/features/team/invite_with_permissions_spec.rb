require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Set user permissions on invite', type: :feature do
  include_context 'with a mocked notifications client'

  let(:invited_email) { 'invited@gov.uk' }
  let(:invited_user) { User.find_by(email: invited_email) }

  before do
    sign_in_user create(:user)
    visit new_user_invitation_path
    fill_in 'Email', with: invited_email
  end

  context 'when setting all the permissions' do
    before do
      click_on 'Send invitation email'
    end

    it 'assigns manage team permission to the user' do
      expect(invited_user.permission.can_manage_team?).to eq(true)
    end

    it 'assigns manage locations permission to the user' do
      expect(invited_user.permission.can_manage_locations?).to eq(true)
    end
  end

  context 'when setting only one permission' do
    before do
      uncheck 'Add and remove locations and IPs'
      click_on 'Send invitation email'
    end

    it 'assigns manage team permission to the user' do
      expect(invited_user.permission.can_manage_team?).to eq(true)
    end

    it 'does not assign manage locations permission to the user' do
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end

  context 'when setting no permissions' do
    before do
      uncheck 'Add and remove locations and IPs'
      uncheck 'Add and remove team members'
      click_on 'Send invitation email'
    end

    it 'does not assign manage team permission to the user' do
      expect(invited_user.permission.can_manage_team?).to eq(false)
    end

    it 'does not assign manage locations permission to the user' do
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end
end
