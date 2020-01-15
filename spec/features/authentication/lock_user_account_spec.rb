require "support/notifications_service"

describe "Locking a user account", type: :feature do
  include_context "with a mocked notifications client"

  let(:correct_password) { "rupaul 9232 !!foo" }
  let(:incorrect_password) { "incorrectpassword" }
  let(:user) { create(:user, password: correct_password) }

  before { visit new_user_session_path }

  context "when they login ten consecutive times with the wrong password" do
    before do
      10.times do
        fill_in "Email", with: user.email
        fill_in "Password", with: incorrect_password
        click_on "Continue"
      end
    end

    it "displays a generic response" do
      expect(page).to have_content "Invalid Email or password."
    end

    it "disregards any further attempts to sign in" do
      fill_in "Email", with: user.email
      fill_in "Password", with: correct_password
      click_on "Continue"

      expect(page).to have_link "Admin"
    end

    it "triggers a notification to be sent" do
      expect(notifications.count).to eq 1
    end

    it "sends an unlock email" do
      expect(last_notification_type).to eq "unlock"
    end

    it "sends an unlock link" do
      expect(last_notification_link).to include(user_unlock_path)
    end
  end
end
