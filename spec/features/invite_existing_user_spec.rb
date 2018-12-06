require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case_spy'
require 'support/confirmation_use_case'

describe 'inviting a user that has already signed up', focus: true do
  let(:user) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:second_invited_user_email) { 'notconfirmedyet@gov.uk' }

  context 'when invited user has been confirmed before invite' do
    include_examples 'invite use case spy'
    include_examples 'notifications service'

    before do
      sign_in_user user
      visit root_path
      click_on "Team members"
      click_on "Invite team member"
      fill_in "Email", with: invited_user.email
    end

    it "tells the user that the email has already been taken" do
      expect {
        click_on "Send invitation email"
      }.to change { User.count }.by(0)
      expect(InviteUseCaseSpy.invite_count).to eq(0)
      expect(page).to have_content("Email is already invited, or already registered with another organisation")
    end

    context 'when invited existing user logs into their account afterwards' do
      before do
        login_as(invited_user, scope: :user)
        visit root_path
      end

      it 'signs in the invited user' do
        expect(page).to have_content 'Sign out'
      end

      it 'has no errors upon signing in' do
        expect(page).to_not have_content('Something went wrong while processing the request')
      end
    end
  end

  context 'when invited user has already signed up but NOT yet confirmed their account' do
    include_examples 'confirmation use case spy'
    include_examples 'invite use case spy'
    include_examples 'notifications service'

    context 'and based on what is expected of the user sign up path'do
      it 'sends the confirmation link' do
        expect {
          sign_up_for_account(email: second_invited_user_email)
        }.to change { ConfirmationUseCaseSpy.confirmations_count }.by(1)
        expect(URI(confirmation_email_link).scheme).to eq("https")
      end
    end

    context 'and another confirmed user invites them' do
      before do
        sign_up_for_account(email: second_invited_user_email)
        sign_in_user user
        visit root_path
        click_on "Team members"
        click_on "Invite team member"
        fill_in "Email", with: second_invited_user_email
      end

      it "tells the user that the email has already been taken" do
        expect {
          click_on "Send invitation email"
        }.to change { User.count }.by(0)
        expect(InviteUseCaseSpy.invite_count).to eq(0)
        expect(page).to have_content("Email is already invited, or already registered with another organisation")
      end

    end
  end
end
