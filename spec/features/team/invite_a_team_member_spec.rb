require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe "Invite a team member" do
  include_examples 'invite use case spy'
  include_examples 'notifications service'
  include_examples 'confirmation use case spy'

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
      click_on "Team"
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

      context "for new user with gov.uk email address" do
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

      context "for new user with non gov.uk email address" do
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
        context "and is confirmed" do
          let(:invited_user_email) { user.email }

          it "tells the user that the email has already been taken" do
            expect {
              click_on "Send invitation email"
            }.to change { User.count }.by(0)
            expect(InviteUseCaseSpy.invite_count).to eq(0)
            expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
          end
        end

        context "when user is not confirmed and has no organisation" do
          before do
            sign_out
            sign_up_for_account(email: invited_user_email)
            sign_in_user user
            visit root_path
            click_on "Team"
            click_on "Invite team member"
            fill_in "Email", with: invited_user_email
          end

          let(:invited_user_email) { 'notconfirmedyet@gov.uk' }
          let(:invited_user) { User.find_by(email: invited_user_email) }

          it "sends them an invite to the organisation's account" do
            expect {
              click_on "Send invitation email"
            }.to change { User.count }.by(0)
            expect(InviteUseCaseSpy.invite_count).to eq(1)
            expect(invited_user.confirmed?).to eq(false)
            expect(invited_user.organisation_id).to eq(user.organisation_id)
          end
        end

        context "when user is not confirmed but has a organisation" do
          let(:organisation) { create(:organisation) }
          let(:invited_user) { create(:user, organisation: organisation, confirmed_at: nil) }
          let(:invited_user_email) { invited_user.email }

          it "does not send them an invite to the organisation's account" do
            expect {
              click_on "Send invitation email"
            }.to change { User.count }.by(0)
            expect(InviteUseCaseSpy.invite_count).to eq(0)
            expect(invited_user.confirmed?).to eq(false)
            expect(invited_user.organisation_id).to_not eq(user.organisation_id)
          end
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
