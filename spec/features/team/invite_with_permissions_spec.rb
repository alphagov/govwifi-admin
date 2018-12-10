require 'features/support/sign_up_helpers'
require 'support/notifications_service'

describe 'Set user permissions on invite', focus: true do
  include_examples 'notifications service'

  let(:user) { create(:user) }
  let(:invited_email) { 'invited@gov.uk' }
  let(:invited_user) { User.find_by(email: invited_email) }

  before do
    sign_in_user user
    visit new_user_invitation_path
  end

  context 'Given I set all the permissions' do
    context 'and I invite an unconfirmed but exiting user' do
      let(:unconfirmed_user) { create(:user, :unconfirmed) }

      it 'should not delete the default permissions from signing up' do
        fill_in 'Email', with: unconfirmed_user.email
        click_on 'Send invitation email'

        expect(unconfirmed_user.permission.can_manage_team?).to eq(true)
        expect(unconfirmed_user.permission.can_manage_locations?).to eq(true)
      end
    end

    it 'should assign all the permissions to the user' do
      fill_in 'Email', with: invited_email
      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(true)
      expect(invited_user.permission.can_manage_locations?).to eq(true)
    end
  end

  context 'Given I set only the .can_manage_team permission' do
    it 'should assign only that permission' do
      fill_in 'Email', with: invited_email
      uncheck 'Manage locations'
      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(true)
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end

  context 'Given I set no permissions' do
    it 'should assign no permissions' do
      fill_in 'Email', with: invited_email
      uncheck 'Manage locations'
      uncheck 'Manage team'

      click_on 'Send invitation email'

      expect(invited_user.permission.can_manage_team?).to eq(false)
      expect(invited_user.permission.can_manage_locations?).to eq(false)
    end
  end
end
