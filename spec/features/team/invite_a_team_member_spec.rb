require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe "Inviting a team member", type: :feature do
  context "when logged out" do
    before do
      visit new_user_invitation_path
    end

    it_behaves_like 'not signed in'
  end

  context "when inviting a team member" do
    let(:user) { create(:user) }

    include_examples 'when sending an invite email'
    include_examples 'notifications service'
    include_examples 'confirmation use case spy'

    # rubocop:disable RSpec/HooksBeforeExamples
    before do
      sign_in_user user
      visit new_user_invitation_path
      fill_in "Email", with: invited_user_email
    end
    # rubocop:enable RSpec/HooksBeforeExamples

    context "with a gov.uk email address" do
      let(:invited_user_email) { "correct@gov.uk" }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        click_on "Send invitation email"
      end

      it "creates an unconfirmed user" do
        expect(invited_user).to be_present
      end

      it "sends an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(1)
      end

      it "sets the invitees organisation" do
        expect(invited_user.organisation).to eq(user.organisation)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path('/team_members/created/invite')
      end
    end

    context "with a non gov.uk email address" do
      let(:invited_user_email) { "incorrect@gmail.com" }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        click_on "Send invitation email"
      end

      it "creates an unconfirmed user" do
        expect(invited_user).to be_present
      end

      it "sends an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(1)
      end

      it "sets the invitees organisation" do
        expect(invited_user.organisation).to eq(user.organisation)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path('/team_members/created/invite')
      end
    end

    context "with an existing confirmed user" do
      let(:invited_user_email) { user.email }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
      end
    end

    context "with an unconfirmed user with no organisation" do
      let(:invited_user_email) { 'notconfirmedyet@gov.uk' }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        sign_out
        sign_up_for_account(email: invited_user_email)
        sign_in_user user
        visit new_user_invitation_path
        fill_in "Email", with: invited_user_email
        click_on "Send invitation email"
      end

      it "results in an unconfirmed user" do
        expect(invited_user).to be_present
      end

      it "sends an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(1)
      end

      it "sets the invitees organisation" do
        expect(invited_user.organisation_id).to eq(user.organisation_id)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path('/team_members/created/invite')
      end
    end

    context "with an unconfirmed user that has already been invited" do
      let(:organisation) { create(:organisation) }
      let!(:invited_user) { create(:user, invitation_sent_at: Time.now, organisation: organisation, confirmed_at: nil) }
      let(:invited_user_email) { invited_user.email }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
      end
    end

    context "without an email address" do
      let(:invited_user_email) { "" }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email can't be blank")
      end
    end

    context "with an invalid email address" do
      let(:invited_user_email) { "hello" }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        expect(InviteUseCaseSpy.invite_count).to eq(0)
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email must be a valid email address")
      end
    end
  end
end
