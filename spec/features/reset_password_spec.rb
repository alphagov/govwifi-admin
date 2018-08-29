require 'support/notifications_service'
require 'support/reset_password_use_case_spy'
require 'support/reset_password_use_case'
require 'support/confirmation_use_case_spy'
require 'support/confirmation_use_case'
require 'features/support/errors_in_form'

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
    before do
      visit new_user_password_path
      fill_in "user_email", with: "user@user.com"
      click_on "Send me reset password instructions"
    end

    it_behaves_like "errors in form"

    it "tells the user the email cannot be found" do
      expect(page).to have_content("Email not found")
    end
  end

  context "when user is not yet confirmed" do
    include_examples 'confirmation use case spy'
    include_examples 'notifications service'

    let(:user) { create(:user) }

    it "sends the confirmation instructions instead of reset password" do
      visit new_user_password_path
      fill_in "user_email", with: user.email

      expect {
        click_on "Send me reset password instructions"
      }.to change { ConfirmationUseCaseSpy.confirmations_count }.by(1)

      expect(page).to have_content("You will receive an email with instructions")
    end
  end

  context "when the user does exist" do
    include_examples 'reset password use case spy'
    include_examples 'notifications service'

    let(:user) { create(:user, :confirmed, :with_organisation) }

    it "sends the reset password instructions" do
      expect {
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_on "Send me reset password instructions"
      }.to change { ResetPasswordUseCaseSpy.reset_count }.by(1)
      expect(page).to have_content("You will receive an email with instructions")
    end

    context "when clicking on reset link" do
      let(:reset_link) { ResetPasswordUseCaseSpy.last_reset_url }
      let(:reset_path) { ResetPasswordUseCaseSpy.last_reset_path_with_query }

      before do
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_on "Send me reset password instructions"
        visit(reset_path)
      end

      it "sends an https link" do
        expect(URI(reset_link).scheme).to eq("https")
      end

      it "redirects user to edit password page" do
        expect(page).to have_content("Change your password")
      end

      context "when entering correct passwords" do
        before do
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_on "Change my password"
        end

        it "changes to users password" do
          expect(page).to have_content("Logout")
        end
      end


      context "when entering a password that is too short" do
        before do
          fill_in "user_password", with: "1"
          fill_in "user_password_confirmation", with: "1"
          click_on "Change my password"
        end

        it_behaves_like "errors in form"

        it "tells the user the password is too short" do
          expect(page).to have_content("Password is too short")
        end
      end

      context "when password confirmation does not match" do
        before do
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password1"
          click_on "Change my password"
        end

        it_behaves_like "errors in form"

        it "tells the user the passwords must match" do
          expect(page).to have_content("Password confirmation doesn't match Password")
        end
      end
    end
  end
end
