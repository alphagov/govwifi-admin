require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe "Invite a team member" do
  include_examples 'invite use case spy'
  include_examples 'notifications service'

  context "when logged out" do
    before do
      visit new_user_invitation_path
    end

    it_behaves_like 'not signed in'
  end

  context "when logged in" do
    let(:user) { create(:user) }
    before do
      sign_in_user user
      visit root_path
      click_on "Organisation"
      click_on "Invite team member"
    end

    it "shows the invites page" do
      expect(page).to have_content("Invite a team member")
    end

    context "when entering a team members email address" do
      include_examples 'invite use case spy'
      include_examples 'notifications service'

      before do
        fill_in "Email", with: invited_user_email
      end

      context "with gov.uk email address" do
        let(:invited_user_email) { "correct@gov.uk" }
        let(:invited_user) { User.find_by(email: invited_user_email) }

        it "creates an unconfirmed user" do
          expect {
            click_on "Send invitation email"
          }.to change { User.count }.by(1)
          expect(InviteUseCaseSpy.invite_count).to eq(1)
          expect(invited_user.confirmed?).to eq(false)
          expect(invited_user.organisation).to eq(user.organisation)
        end
      end

      context "with non gov.uk email address" do
        let(:invited_user_email) { "incorrect@gmail.com" }
        let(:invited_user) { User.find_by(email: invited_user_email) }

        it "creates an unconfirmed user" do
          expect {
            click_on "Send invitation email"
          }.to change { User.count }.by(1)
          expect(InviteUseCaseSpy.invite_count).to eq(1)
          expect(invited_user.confirmed?).to eq(false)
          expect(invited_user.organisation).to eq(user.organisation)
        end
      end

      context "with an email that already exists" do
        let(:invited_user_email) { user.email }

        it "tells the user that the email has already been taken" do
          expect {
            click_on "Send invitation email"
          }.to change { User.count }.by(0)
          expect(InviteUseCaseSpy.invite_count).to eq(0)
          expect(page).to have_content("Email is already invited, or already registered with another organisation")
        end
      end

      context "without an email" do
        let(:invited_user_email) { "" }

        it "tells the user that email cannot be blank" do
          expect {
            click_on "Send invitation email"
          }.to change { User.count }.by(0)
          expect(InviteUseCaseSpy.invite_count).to eq(0)
          expect(page).to have_content("Email can't be blank")
        end
      end

      context "tells user that email must be a valid email address" do
        let(:invited_user_email) { "hello" }

        it "tells the user " do
          expect {
            click_on "Send invitation email"
          }.to change { User.count }.by(0)
          expect(InviteUseCaseSpy.invite_count).to eq(0)
          expect(page).to have_content("Email must be a valid email address")
        end
      end
    end
  end
end
