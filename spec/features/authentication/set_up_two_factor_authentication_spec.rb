require "support/notifications_service"

describe "Set up two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:super_admin_organisation) { create(:organisation, super_admin: true) }
  let(:user) { create(:user, organisations: [super_admin_organisation]) }

  include_context "when using the notifications service"

  before do
    sign_in_user(user, pass_through_two_factor: false)
    visit root_path
  end

  context "with a super admin user" do
    it "enforces 2FA setup" do
      expect(page).to have_current_path(users_two_factor_authentication_setup_path)
    end

    it "presents the setup page" do
      expect(page).to have_content("Two factor authentication setup")
    end

    it "explains the setup step" do
      expect(page).to have_content("Scan the QR code")
    end

    it "presents a QR code" do
      expect(page).to have_css("img[src*='data:image/png;base64']")
    end

    it "labels the text key" do
      expect(page).to have_content("Or, enter this key into your authenticator app:")
    end

    it "presents a text key" do
      expect(page).to have_content(/(([A-Z0-9]){4}  ){7}[A-Z0-9]{4}/)
    end

    it "expects a TOTP code" do
      expect(page).to have_field(:code)
    end

    it "does not display a link to skip 2fa" do
      expect(page).to_not have_link("I cannot set up two factor authentication")
    end

    it "rejects directly visiting the unable to two factor authentication page" do
      visit users_two_factor_authentication_unable_path
      expect(page).to_not have_current_path(users_two_factor_authentication_unable_path)
    end

    context "when navigating to another page" do
      before { visit root_path }

      it "redirects the user back to setup" do
        expect(page).to have_current_path(users_two_factor_authentication_setup_path)
      end
    end

    context "when submitting a valid code" do
      let(:totp_double) { instance_double(ROTP::TOTP) }

      before do
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

    context "when submitting an invalid code" do
      before do
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

  context "with a regular non-super-admin user" do
    let(:user) { create(:user, organisations: [organisation]) }

    it "redirects to the 2fa setup page" do
      expect(page).to have_current_path(users_two_factor_authentication_setup_path)
    end

    context "clicking on I cannot set up 2fa" do
      before do
        click_on "I cannot set up two factor authentication"
      end
      it "goes to the 2fa unable page" do
        expect(page).to have_current_path(users_two_factor_authentication_unable_path)
      end
      context "click on the setup 2fa button" do
        before :each do
          click_on "Setup two factor authentication"
        end
        it "shows the 2fa setup page" do
          expect(page).to have_current_path(users_two_factor_authentication_setup_path)
        end
      end
      context "click on the back link" do
        before :each do
          click_on "Back"
        end
        it "shows the 2fa setup page" do
          expect(page).to have_current_path(users_two_factor_authentication_setup_path)
        end
      end
      context "click on the Continue to GovWifi link" do
        before :each do
          click_on "Continue to GovWifi"
        end
        it "signs in" do
          expect(page).to have_current_path new_organisation_setup_instructions_path
        end
      end
    end
  end
end
