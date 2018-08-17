require 'support/notifications_service'
require 'support/reset_password_use_case_spy'
require 'support/reset_password_use_case'

describe "Resetting a password" do
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
    it "tells the user the email cannot be found" do
      visit new_user_password_path
      fill_in "user_email", with: "user@user.com"
      click_on "Send me reset password instructions"
      expect(page).to have_content("Email not found")
    end
  end

  context "when the user does exist" do
    include_examples 'reset password use case spy'
    include_examples 'notifications service'

    let(:user) { create(:user, :confirmed) }

    it "confirms that the reset instructions have been sent" do
      visit new_user_password_path
      fill_in "user_email", with: user.email
      click_on "Send me reset password instructions"
      expect(page).to have_content("You will receive an email with instructions")
    end

    it "sends the reset password instructions" do
      expect {
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_on "Send me reset password instructions"
      }.to change { ResetPasswordUseCaseSpy.reset_count }.by(1)
    end
  end
end
