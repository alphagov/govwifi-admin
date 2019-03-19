require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'inviting a user that has signed up' do
  include_examples 'invite use case spy'

  let(:confirmed_user) { create(:user) }

  context 'when user is already a confirmed user' do
    let(:betty) { create(:user) }

    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in "Email", with: betty.email
    end

    it "does not send an invitation" do
      expect {
        click_on "Send invitation email"
      }.to change(User, :count).by(0)
      expect(InviteUseCaseSpy.invite_count).to eq(0)
      expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
    end

    context 'and user logs into their account afterwards' do
      before do
        login_as(betty, scope: :user)
        visit root_path
      end

      it 'allows the user to sign in successfully' do
        expect(page).to have_content 'Sign out'
      end

      it 'has no errors upon signing in' do
        expect(page).not_to have_content('An error occurred')
      end

      it 'does not change their default permissions' do
        expect(betty.permission.can_manage_team?).to eq(true)
        expect(betty.permission.can_manage_locations?).to eq(true)
      end
    end
  end

  context 'when user is an unconfirmed user' do
    include_examples 'confirmation use case spy'

    let(:unconfirmed_email) { 'notconfirmedyet@gov.uk' }

    before { sign_up_for_account(email: unconfirmed_email) }

    it 'sends a confirmation link' do
      expect(ConfirmationUseCaseSpy.confirmations_count).to eq(1)
      expect(URI(confirmation_email_link).scheme).to eq("https")
    end

    context 'and is invited by another user' do
      before do
        sign_in_user confirmed_user
        visit new_user_invitation_path
        fill_in "Email", with: unconfirmed_email
        click_on "Send invitation email"
      end

      it "does not send an invitation" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
        expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
      end

      context 'when user uses the confirmation link after invitation attempt' do
        let(:claire) { User.find_by(email: unconfirmed_email) }

        before { visit confirmation_email_link }

        it 'redirects them to a page to finish creating their account' do
          expect(page).to have_content("Your name")
          expect(page).to have_content("Create your account")
        end

        it 'does not change the default permissions from signing up' do
          expect(claire.permission.can_manage_team?).to eq(true)
          expect(claire.permission.can_manage_locations?).to eq(true)
        end

        it 'signs them in successfully' do
          update_user_details(name: 'claire', organisation_name: 'Org 2')
          expect(page).to have_content 'Sign out'
        end

        it 'displays no errors upon signing in' do
          expect(page).not_to have_content('An error occurred')
        end
      end
    end
  end
end
