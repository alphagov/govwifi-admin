require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Cross organistion team permissions', type: :feature, focus: true do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user, :with_organisation) }
  let(:invited_user_email) { "correct@gov.uk" }
  let(:invited_user) { User.find_by(email: invited_user_email) }

  context 'invite a user with permissions' do
    before do
      sign_in_user user
      visit new_user_invitation_path
      fill_in "Email", with: invited_user_email
    end

    it 'has the same permissions across all assosciated organisations' do
      click_on "Send invitation email"
      invited_user.permission.update!(can_manage_team: true)
      invited_user.permission.update!(can_manage_locations: true)
      expect(invited_user).to be_present
    end
  end
end
