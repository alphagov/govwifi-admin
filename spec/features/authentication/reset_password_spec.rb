describe "Resetting a password", type: :feature do
  include EmailHelpers
  it "displays the forgot password link at login" do
    visit root_path
    expect(page).to have_content("Forgot your password?")
  end

  it "links to forgot password form" do
    visit root_path
    click_on "Forgot your password?"
    expect(page).to have_content("Reset your GovWifi administrator password")
  end

  context "when the user has never signed up" do
    before do
      visit new_user_password_path
      fill_in "Enter your email address", with: "user@user.com"
      click_on "Send me reset password instructions"
    end

    it "displays a generic response" do
      expect(page).to have_content("If you have an account with us, you will receive an email with a password reset link shortly.")
    end

    it "sends no email" do
      it_did_not_send_any_emails
    end
  end

  context "when the user has signed up but has NOT been confirmed" do
    let(:user) { create(:user, :unconfirmed) }

    before do
      visit new_user_password_path
      fill_in "Enter your email address", with: user.email
      click_on "Send me reset password instructions"
    end

    it "tells them to confirm their account first" do
      expect(page).to have_content("Resend confirmation instructions")
    end

    it "resends the confirm email" do
      expect(Services.notify_gateway.last_email_parameters).to include(
        personalisation: { confirmation_url: include(user_confirmation_path) },
        reference: "confirmation_email",
        template_id: "confirmation_email_template",
      )
    end
  end

  context "when the user has signed up and has been confirmed" do
    let(:user) { create(:user) }

    before do
      visit new_user_password_path
      fill_in "Enter your email address", with: user.email
      click_on "Send me reset password instructions"
    end

    it "displays a generic response" do
      expect(page).to have_content("If you have an account with us, you will receive an email with a password reset link shortly.")
    end

    it "sends a reset password email" do
      expect(Services.notify_gateway.last_email_parameters).to include(
        personalisation: { reset_url: include(edit_user_password_path) },
        reference: "reset_password_email",
        template_id: "reset_password_email_template",
      )
    end
  end

  context "when clicking on the reset link" do
    let(:user) { create(:user) }

    before do
      visit new_user_password_path
      fill_in "Enter your email address", with: user.email
      click_on "Send me reset password instructions"
      visit(Services.notify_gateway.last_reset_password_url)
    end

    it "sends an https link" do
      expect(Services.notify_gateway.last_email_parameters).to include(
        personalisation: { reset_url: include("https://") },
      )
    end

    it "redirects the user to the edit password page" do
      expect(page).to have_content("Change your password")
    end

    context "when entering a password that is 6 to 80 characters long" do
      before do
        fill_in "New password", with: "newBUT str0ng passsssssword"
        click_on "Change my password"
      end

      it "automatically signs them out" do
        expect(page).to_not have_content("Sign out")
      end

      it "tells the user their password has been changed" do
        expect(page).to have_content("Your password has been changed successfully")
      end
    end

    context "when entering a password that is less than 6 characters" do
      before do
        fill_in "New password", with: "pass"
        click_on "Change my password"
      end

      it_behaves_like "errors in form"

      it "tells the user the password is too short" do
        expect(page).to have_content("Password is too short")
      end
    end
  end
end
