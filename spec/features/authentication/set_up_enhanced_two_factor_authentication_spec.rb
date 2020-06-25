describe "Set up two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:super_admin_organisation) { create(:organisation, super_admin: true) }
  let(:user) { create(:user, organisations: [super_admin_organisation]) }

  before do
    allow(Rails.application.config).to receive(:enable_enhanced_2fa_experience).and_return true
    sign_in_user(user, pass_through_two_factor: false)
    visit root_path
  end

  it "presents the setup page" do
    expect(page).to have_current_path("/users/two_factor_authentication/setup")
  end

  it "explains the setup step" do
    expect(page).to have_content("Set up two-factor authentication")
  end

  it "provides the option to receive 2FA codes via email" do
    expect(page).to have_field("Email")
  end

  it "provides the option to generate 2FA codes by authentication app" do
    expect(page).to have_field("Authentication app for smartphone or tablet")
  end

  context "when navigating to another page" do
    before { visit logs_path }

    it "redirects the user back to setup" do
      expect(page).to have_current_path("/users/two_factor_authentication/setup")
    end
  end

  context "when admin user chooses email as the 2FA method" do
    before do
      choose "Email"
      click_on "Continue"
    end

    it "explains that 2FA codes will be sent by email" do
      expect(page).to have_content("Two-factor authentication")
      expect(page).to have_content("We can send security codes to the email address")
      expect(page).to have_button("Complete setup")
      expect(page).to have_link("Back")
    end
  end

  context "when admin user completes email-based 2FA setup" do
    before do
      choose "Email"
      click_on "Continue"
      click_on "Complete setup"
    end

    it "confirms that an email with 2FA code has been sent" do
      expect(page).to have_content("We have emailed you a link to sign in to GovWifi")
    end

    it "explains what can be done in case email is not received" do
      expect(page).to have_css("#resend-email")
    end
  end

  context "when admin user requests to re-send TOTP email" do
    before do
      choose "Email"
      click_on "Continue"
      click_on "Complete setup"
      click_on "we can try sending it again"
    end

    it "allows requesting to re-send TOTP email" do
      expect(page).to have_button("Resend email")
    end
  end

  context "when admin user chooses app as the 2FA method" do
    before do
      choose "app"
      click_on "Continue"
    end

    it "shows QR code to scan" do
      expect(page).to have_css("img[src*='data:image/png;base64']")
    end

    it "expects a TOTP code" do
      expect(page).to have_field(:code)
    end
  end

  context "when admin user completes app-based 2FA setup using a valid code" do
    let(:totp_double) { instance_double(ROTP::TOTP) }

    before do
      choose "app"
      click_on "Continue"

      allow(ROTP::TOTP).to receive(:new).and_return(totp_double)
      allow(totp_double).to receive(:verify).and_return(true)

      fill_in :code, with: "999999"
      click_on "Complete setup"
    end

    it "authenticates the user" do
      expect(user.reload.totp_enabled?).to be true
    end

    it "shows a success message" do
      expect(page).to have_content("Two factor authentication setup successful")
    end

    it "redirects the user to the admin app" do
      expect(page).to have_current_path(super_admin_organisations_path)
    end
  end

  context "when admin user completes app-based 2FA setup using an invalid code" do
    before do
      choose "app"
      click_on "Continue"

      fill_in :code, with: "123456"
      click_on "Complete setup"
    end

    it "returns an error" do
      expect(page).to have_content("Six digit code is not valid")
    end

    it "returns to the 2FA screen" do
      expect(page).to have_content("Scan the QR code")
    end

    it "doesn't store a totp for the user" do
      expect(user.otp_secret_key).to be nil
    end
  end
end
