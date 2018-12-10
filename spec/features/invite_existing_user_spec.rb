require 'features/support/sign_up_helpers'
require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'inviting a user that has already signed up' do
  include_examples 'invite use case spy'

  let(:confirmed_user) { create(:user) }

  context 'when betty has a confirmed account before being invited by a confirmed user' do
    let(:betty) { create(:user) }

    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in "Email", with: betty.email
    end

    it "does not send an invitation to an existing user" do
      expect {
        click_on "Send invitation email"
      }.to change { User.count }.by(0)
      expect(InviteUseCaseSpy.invite_count).to eq(0)
      expect(page).to have_content("Email is already invited, or already registered with another organisation")
    end

    context 'when betty signs into their account after the confirmed user tried to invite them' do
      before do
        login_as(betty, scope: :user)
        visit root_path
      end

      it 'allows betty to sign in successfully' do
        expect(page).to have_content 'Sign out'
      end

      it 'has no errors upon signing in' do
        expect(page).to_not have_content('An error occurred')
      end

      it 'should not change their default permissions from signing up' do
        expect(betty.permission.can_manage_team?).to eq(true)
        expect(betty.permission.can_manage_locations?).to eq(true)
      end
    end
  end

  context 'when claire has already signed up but has NOT yet confirmed their account' do
    include_examples 'confirmation use case spy'

    let(:claires_email) { 'notconfirmedyet@gov.uk' }

    before { sign_up_for_account(email: claires_email) }

    it 'sends a confirmation link to claire' do
      expect(ConfirmationUseCaseSpy.confirmations_count).to eq(1)
      expect(URI(confirmation_email_link).scheme).to eq("https")
    end

    context 'and a confirmed user invites them' do
      before do
        sign_in_user confirmed_user
        visit new_user_invitation_path
        fill_in "Email", with: claires_email
        click_on "Send invitation email"
      end

      it "does not send an invitation to an existing user" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
        expect(page).to have_content("Email is already invited, or already registered with another organisation")
      end

      context 'when claire visits the confirmation link after the confirmed user tried to invite them' do
        let(:claire) { User.find_by(email: claires_email) }

        before { visit confirmation_email_link }

        it 'redirects them to a page to finish creating their account' do
          expect(page).to have_content("Your name")
          expect(page).to have_content("Create your account")
        end

        it 'should not change the default permissions from signing up' do
          expect(claire.permission.can_manage_team?).to eq(true)
          expect(claire.permission.can_manage_locations?).to eq(true)
        end

        it 'signs them in successfully after they have completed creating their account' do
          update_user_details(name: 'claire')
          expect(page).to have_content 'Sign out'
        end

        it 'displays no errors upon signing in' do
          expect(page).to_not have_content('An error occurred')
        end
      end
    end
  end
end
