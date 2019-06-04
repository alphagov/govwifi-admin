require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/membership_invite_use_case'

describe "Inviting a user to their first organisation", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:invitor) { create(:user, organisations: [organisation]) }

  context 'when the user does not exist yet' do
    let(:invitee_email) { 'newuser@gov.uk' }

    include_context 'when using the notifications service'
    include_context 'when sending a membership invite email'
    include_context 'when sending an invite email'

    before do
      sign_in_user invitor
      visit new_user_invitation_path
      fill_in 'Email', with: invitee_email
      click_on 'Send invitation email'
    end

    it 'sends a invitation to confirm the users account' do
      expect(InviteUseCaseSpy.invite_count).to eq(1)
    end

    it 'does not send an additional membership invitation' do
      expect(MembershipInviteUseCaseSpy.invite_count).to eq(0)
    end

    context 'when the invited user accepts the invitation' do
      let(:user) { User.find_by(email: invitee_email) }

      before do
        membership = user.membership_for(organisation)
        visit InviteUseCaseSpy.last_invite_url
        fill_in "Your name", with: "Invitee"
        fill_in "Password", with: "password"
        click_on "Create my account"
      end

      it 'allows the user to sign in successfully' do
        expect(page).to have_content 'Sign out'
      end
    end
  end
end
