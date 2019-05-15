require 'support/cross_organisation_invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Inviting an existing user', type: :feature do
  let(:betty) { create(:user, :with_organisation) }
  let(:confirmed_user) { create(:user, :with_organisation) }

  include_examples 'when sending a cross organisation invite email'

  context 'with a confirmed user' do
    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: betty.email
      click_on 'Send invitation email'
    end

    it 'sends an invitation' do
      expect(CrossOrganisationInviteUseCaseSpy.invite_count).to eq(1)
    end

    it 'creates a join organisation invitation' do
      expect(betty.cross_organisation_invitations.count).to eq(1)
    end

    it 'notifies the user with a success message' do
      expect(page).to have_content("#{betty.email} has been invited to join #{confirmed_user.organisations.first.name}")
    end

    it 'lists cross-organisation invited users' do
      visit team_members_path
      expect(page).to have_content("#{betty.name} #{betty.email} (invited)")
    end
  end
end
