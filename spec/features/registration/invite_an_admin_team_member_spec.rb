describe "Inviting an admin team member on registration", type: :feature do
  include EmailHelpers
  let(:user) { create(:user, :with_organisation) }

  before do
    sign_in_user user
    visit invite_second_admin_path
    fill_in "Email", with: invited_user_email
  end

  context "with a gov.uk email address" do
    let(:invited_user_email) { "correct@gov.uk" }
    let(:invited_user) { User.find_by(email: invited_user_email) }

    before do
      click_on "Invite as an admin"
    end

    it "creates an unconfirmed user" do
      expect(invited_user).to be_present
    end

    it "sends an invite" do
      it_sent_an_invitation_email_once
    end
  end

  context "with an existing user" do
    let(:invited_user_email) { user.email }

    before do
      click_on "Invite as an admin"
    end

    it "does not send an invite" do
      it_did_not_send_any_emails
    end

    it "displays the correct error message" do
      expect(page).to have_content("This email address is already associated with an administrator account")
    end
  end

  context "with an invalid email address" do
    let(:invited_user_email) { "hello" }

    before do
      click_on "Invite as an admin"
    end

    it "does not send an invite" do
      it_did_not_send_any_emails
    end

    it "displays the correct error message" do
      expect(page).to have_content("Email is not a valid email address")
    end
  end
end
