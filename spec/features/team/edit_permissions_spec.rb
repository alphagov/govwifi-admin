describe 'Edit user permissions', type: :feature do
  let(:user) { create(:user) }
  let(:invited_user_other_org) { User.find_by(email: 'invited_other_org@gov.uk') }
  let(:invited_user_same_org) { User.find_by(email: 'invited_same_org@gov.uk') }

  before do
    create(:user, email: 'invited_other_org@gov.uk')
    create(:user, email: 'invited_same_org@gov.uk', organisation: user.organisation)
    sign_in_user user
  end

  context 'without the .can_manage_team permission' do
    before do
      user.permission.update!(can_manage_team: false)
    end

    it 'does not show the edit team member link' do
      visit team_members_path
      expect(page).not_to have_link('Edit permissions')
    end

    it 'prevents visiting the edit permissions page directly' do
      expect {
        visit edit_team_member_path(invited_user_same_org)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'with the .can_manage_team permission' do
    context 'when the user belongs to my organisation' do
      before do
        visit team_members_path
        click_link 'Edit permissions'
        uncheck 'Add and remove team members'
        uncheck 'Add and remove locations and IPs'
        click_on 'Save'
      end

      it 'correctly sets the manage team permissions' do
        expect(invited_user_same_org.can_manage_team?).to eq(false)
      end

      it 'correctly sets the manage locations permissions' do
        expect(invited_user_same_org.can_manage_locations?).to eq(false)
      end

      it 'sets the correct success message' do
        expect(page).to have_content('Permissions updated')
      end

      it 'redirects to "after permission updated" team members page for analytics' do
        expect(page).to have_current_path('/team_members/updated/permissions')
      end
    end

    context 'when the user does not belong to my organisation' do
      it 'restricts editing to only users in my organisation' do
        expect {
          visit edit_team_member_path(invited_user_other_org)
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
