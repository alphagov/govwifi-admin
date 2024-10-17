describe "Inviting a team member", type: :feature do
  include EmailHelpers
  context "when logged out" do
    before do
      visit new_user_invitation_path
    end

    it_behaves_like "not signed in"
  end

  context "when inviting a team member" do
    let(:user) { create(:user, :with_organisation) }

    before do
      sign_in_user user
      visit new_user_invitation_path
      fill_in "Email", with: invited_user_email
      choose("Administrator")
    end

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
        it_sent_an_invitation_email_once
      end

      it "sets the invitees organisation" do
        organisations = invited_user.organisations
        expect(organisations).to eq(user.organisations)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path("/memberships")
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
        it_sent_an_invitation_email_once
      end

      it "sets the invitees organisation" do
        expect(invited_user.organisations).to eq(user.organisations)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path("/memberships")
      end
    end

    context "with an existing confirmed user" do
      let(:invited_user_email) { user.email }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        it_did_not_send_any_emails
      end

      it "displays the correct error message" do
        expect(page).to have_content("This email address is already associated with an administrator account")
      end
    end

    context "with an unconfirmed user with no organisation" do
      let(:invited_user_email) { "notconfirmedyet@gov.uk" }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        sign_out
        sign_up_for_account(email: invited_user_email)

        sign_in_user user
        visit new_user_invitation_path
        fill_in "Email", with: invited_user_email
        choose "Administrator"
        click_on "Send invitation email"
      end

      it "results in an unconfirmed user" do
        expect(invited_user).to be_present
      end

      it "sends an invite" do
        it_sent_an_invitation_email_once
      end

      it "sets the invitees pending organisation" do
        expect(invited_user.pending_membership_for?(organisation: user.organisations.first)).to eq(true)
      end

      it 'redirects to the "after user invited" path for analytics' do
        expect(page).to have_current_path("/memberships")
      end
    end

    context "with an unconfirmed user that has already been invited" do
      let!(:invited_user) { create(:user, invitation_sent_at: Time.zone.now, organisations: user.organisations, confirmed_at: nil) }
      let(:invited_user_email) { invited_user.email }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        it_did_not_send_an_invitation_email
      end
    end

    context "without an email address" do
      let(:invited_user_email) { "" }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        it_did_not_send_an_invitation_email
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email can't be blank").twice
      end
    end

    context "with an invalid email address" do
      let(:invited_user_email) { "hello" }

      before do
        click_on "Send invitation email"
      end

      it "does not send an invite" do
        it_did_not_send_any_emails
      end

      it "displays the correct error message" do
        expect(page).to have_content("Email is not a valid email address").twice
      end
    end
  end
end
