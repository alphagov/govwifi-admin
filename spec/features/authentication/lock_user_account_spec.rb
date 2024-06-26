require "support/notifications_service"

describe "Locking a user account", type: :feature do
  let(:correct_password) { "rupaul 9232 !!foo" }
  let(:incorrect_password) { "incorrectpassword" }
  let(:user) { create(:user, password: correct_password) }

  before do
    allow(Services).to receive(:email_gateway).and_return(EmailGatewaySpy.new)
    visit new_user_session_path
  end

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

    it "sends an unlock email" do
      expect(Services.email_gateway.last_message).to include(
        locals: { unlock_url: include(user_unlock_path) },
        reference: "unlock_account",
        template_id: "unlock_account_template",
      )
    end
  end
end
