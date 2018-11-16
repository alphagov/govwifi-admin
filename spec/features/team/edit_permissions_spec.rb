require 'features/support/sign_up_helpers'

describe 'Edit user permissions' do
  let(:user) { create(:user, :confirmed) }
  let(:invited_user_other_org) { User.find_by(email: 'invited_other_org@gov.uk') }
  let(:invited_user_same_org) { User.find_by(email: 'invited_same_org@gov.uk') }

  before do
    create(:user, :confirmed, email: 'invited_other_org@gov.uk')
    create(:user, :confirmed, email: 'invited_same_org@gov.uk', organisation: user.organisation)
    sign_in_user user
  end

  context 'When I do not have the .can_manage_team permission' do
    before do
      user.permission.update!(can_manage_team: false)
    end

    it 'does not show the edit team member link' do
      visit team_members_path
      expect(page).to_not have_link('Edit permissions')
    end

    it 'Prevents visiting the edit permissions page directly' do
      expect {
        visit edit_permission_path(invited_user_same_org.permission)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'When I have the .can_manage_team permission' do
    context 'User belongs to my organisation' do

      before do
        visit team_members_path
      end

      it 'allows me to edit the user permissions' do
        visit team_members_path
        click_link 'Edit permissions'
        uncheck 'Manage team'
        uncheck 'Manage locations'

        click_on 'Save'

        expect(invited_user_same_org.can_manage_team?).to eq(false)
        expect(invited_user_same_org.can_manage_locations?).to eq(false)
        expect(page).to have_content('Permissions updated')
      end
    end

    context 'User does not belong to my organisation' do
      it 'Restricts editing to only users in my organisation' do
        expect {
          visit edit_permission_path(invited_user_other_org.permission)
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
