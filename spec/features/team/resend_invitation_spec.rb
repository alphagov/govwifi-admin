require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe 'Resend invitation to team member' do
  context 'resend invitation' do
    include_examples 'invite use case spy'
    include_examples 'notifications service'

    let(:user) { create(:user) }
    let(:invited_user_email) { 'invited@gov.uk' }

    before do
      sign_in_user user
      invite_user(invited_user_email)
      visit team_members_path
    end

    it 'shows that the invitation is pending' do
      expect(page).to have_content('Invitation pending')
    end

    it 'sends an invitation' do
      expect { click_on 'Resend invite' }.to \
        change { InviteUseCaseSpy.invite_count }.by(1)
    end

    context 'signup from resent invitation' do
      let(:invite_link) { InviteUseCaseSpy.last_invite_url }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        visit invite_link
      end

      it 'displays the sign up page' do
        expect(page).to have_content('Create your account')
      end

      context 'signing up as an invited user' do
        before do
          fill_in 'Your name', with: 'Ron Swanson'
          fill_in 'Password', with: 'password'
          click_on 'Create my account'
        end

        it 'confirms the user' do
          expect(invited_user.confirmed?).to eq(true)
          expect(invited_user.name).to eq('Ron Swanson')
          expect(page).to have_content('Sign out')
          expect(page).to have_content(user.organisation.name)
        end
      end
    end
  end
end
