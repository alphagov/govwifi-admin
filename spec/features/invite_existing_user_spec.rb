require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case_spy'
require 'support/confirmation_use_case'

describe 'inviting a user that has already signed up', focus: true do
  include_examples 'invite use case spy'
  include_examples 'notifications service'

  let(:alice) { create(:user) }

  context 'when invitee has a confirmed account before invitation' do
    let(:betty) { create(:user) }

    before do
      sign_in_user alice
      visit root_path
      click_on "Team members"
      click_on "Invite team member"
      fill_in "Email", with: betty.email
    end

    it "tells the inviter that the email is already registered to the platform" do
      expect {
        click_on "Send invitation email"
      }.to change { User.count }.by(0)
      expect(InviteUseCaseSpy.invite_count).to eq(0)
      expect(page).to have_content("Email is already invited, or already registered with another organisation")
    end

    context 'when invitee signs into their account after the failed invitation' do
      before do
        login_as(betty, scope: :user)
        visit root_path
      end

      it 'allows invitee to sign in' do
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

  context 'when invitee has already signed up but has NOT yet confirmed their account' do
    include_examples 'confirmation use case spy'

    let(:claires_email) { 'notconfirmedyet@gov.uk' }

    before { sign_up_for_account(email: claires_email) }

    it 'sends a confirmation link to the new user' do
      expect(ConfirmationUseCaseSpy.confirmations_count).to eq(1)
      expect(URI(confirmation_email_link).scheme).to eq("https")
    end

    context 'and a confirmed user invites them' do
      before do
        sign_in_user alice
        visit root_path
        click_on "Team members"
        click_on "Invite team member"
        fill_in "Email", with: claires_email
        click_on "Send invitation email"
      end

      it "does not send an invitation" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
        expect(page).to have_content("Email is already invited, or already registered with another organisation")
      end

      context 'when unconfirmed invitee clicks on the confirmation link after failed invitation' do
        let(:claire) { User.find_by(email: claires_email) }

        before do
          sign_out
          visit confirmation_email_link
        end

        it 'allows them to finish creating their account' do
          expect(page).to have_content("Organisation name")
          expect(page).to have_content("Service email")
          expect(page).to have_content("Your name")
          expect(page).to have_content("Password")
          expect(page).to have_content("Create your account")
        end

        # Broken behaviour seems to be due to the unconfirmed user's permmissions
        it 'should not change the default permissions from signing up' do
          expect(claire.permission.can_manage_team?).to eq(true)
          expect(claire.permission.can_manage_locations?).to eq(true)
        end

        # This is broken behaviour
        xit 'signs them in but has an error on the page' do
          update_user_details(name: 'claire')
          expect(page).to have_content('Something went wrong while processing the request')
        end

        # This is desired behaviour
        xit 'signs them in' do
          update_user_details(name: 'claire')
          expect(page).to have_content 'Sign out'
        end
      end
    end
  end
end
