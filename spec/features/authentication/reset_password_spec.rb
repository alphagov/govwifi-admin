require 'support/notifications_service'

describe "Resetting a password", type: :feature do
  include_context 'with a mocked notifications client'

  it "displays the forgot password link at login" do
    visit root_path
    expect(page).to have_content("Forgot your password?")
  end

  it "links to forgot password form" do
    visit root_path
    click_on "Forgot your password?"
    expect(page).to have_content("Reset your password")
  end

  context "when user does not exist" do
    before do
      visit new_user_password_path
      fill_in "user_email", with: "user@user.com"
      click_on "Send me reset password instructions"
    end

    it_behaves_like "errors in form"

    it "tells the user the email cannot be found" do
      expect(page).to have_content("Email not found")
    end

    it 'sends no email' do
      expect(notifications).to be_empty
    end
  end

  context "when user is not yet confirmed" do
    let(:user) { create(:user, :unconfirmed) }

    before do
      visit new_user_password_path
      fill_in "user_email", with: user.email
      click_on "Send me reset password instructions"
    end

    it "tells them to confirm their account first" do
      expect(page).to have_content("Resend confirmation instructions")
    end

    it "resends the confirm email" do
      expect(last_notification_type).to eq "confirm"
    end
  end

  context "when the user does exist" do
    let(:user) { create(:user) }

    before do
      visit new_user_password_path
      fill_in "user_email", with: user.email
      click_on "Send me reset password instructions"
    end

    it "sends a reset password email" do
      expect(last_notification_type).to eq "reset"
    end

    it "displays a confirmation message to the user" do
      expect(page).to have_content("You will receive an email with instructions")
    end
  end

  context "when clicking on reset link" do
    let(:user) { create(:user) }

    before do
      visit new_user_password_path
      fill_in "user_email", with: user.email
      click_on "Send me reset password instructions"
      visit(last_notification_link)
    end

    it "sends an https link" do
      expect(URI(last_notification_link).scheme).to eq("https")
    end

    it "redirects user to edit password page" do
      expect(page).to have_content("Change your password")
    end

    context "when entering correct passwords" do
      before do
        fill_in "user_password", with: "password"
        click_on "Change my password"
      end

      it "changes to users password" do
        expect(page).to have_content("Sign out")
      end
    end

    context "when entering a password that is too short" do
      before do
        fill_in "user_password", with: "1"
        click_on "Change my password"
      end

      it_behaves_like "errors in form"

      it "tells the user the password is too short" do
        expect(page).to have_content("Password is too short")
      end
    end
  end
end
