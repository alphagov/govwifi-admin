require "support/notifications_service"

describe "Set up two factor authentication", type: :feature do
  let(:correct_password) { "onetwo123!" }
  let(:correct_totp_code) { "123456" }
  let(:incorrect_totp_code) { "999999" }

  include_context "when using the notifications service"

  before :each do
    allow_any_instance_of(ROTP::TOTP).to receive(:verify).with(correct_totp_code, anything).and_return(true)
    allow_any_instance_of(ROTP::TOTP).to receive(:verify).with(incorrect_totp_code, anything).and_return(false)
    allow(Rails.application.config).to receive(:enable_enhanced_2fa_experience).and_return true
  end

  context "The user has an organisation" do
    before do
      @user = create(:user,
                     email: "tom@gov.uk",
                     password: correct_password,
                     name: "tom",
                     organisations: [create(:organisation)])
      @user.confirm

      visit root_path

      fill_in "Email", with: "tom@gov.uk"
      fill_in "Password", with: correct_password

      click_on "Continue"

      visit root_path
    end

    it "does not send an email" do
      expect(notification_instance).to_not have_received(:send_email)
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

      it "does not send an email" do
        expect(notification_instance).to_not have_received(:send_email)
      end
    end

    context "when user chooses email as the 2FA method" do
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

      it "does not send an email" do
        expect(notification_instance).to_not have_received(:send_email)
      end
    end

    context "when user completes email-based 2FA setup" do
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

      it "sends an email" do
        expect(notification_instance).to have_received(:send_email)
      end

      context "the user resends the email" do
        before :each do
          click_link "resend-email"
        end

        it "explains the email can be sent again" do
          expect(page).to have_content("Emails sometimes take a few minutes to arrive.")
          expect(page).to have_content("If you do not receive the email, we can send you a new one.")
        end

        it "does not send further emails" do
          expect(notification_instance).to have_received(:send_email).once
        end

        context "the user confirms" do
          before :each do
            click_on "Resend email"
          end

          it "sends another email" do
            expect(notification_instance).to have_received(:send_email).twice
          end

          it "explains another email has been sent" do
            expect(page).to have_content("We have emailed you another link to sign in to GovWifi.")
          end
        end
      end

      context "The user signs in" do
        before :each do
          visit users_two_factor_authentication_direct_otp_path(code: @user.reload.direct_otp)
        end

        it "sucessfully sets up 2fa" do
          expect(page).to have_content("Two factor authentication setup successful")
        end

        context "The user signs out and back in again" do
          before :each do
            click_on "Sign out"
            visit root_path

            fill_in "Email", with: "tom@gov.uk"
            fill_in "Password", with: correct_password
            click_on "Continue"
          end

          it "sends an email again" do
            expect(notification_instance).to have_received(:send_email).twice
          end

          it "asks for the email 2FA method when user logs in again" do
            expect(page).to have_content("We have emailed you a link to sign in to GovWifi.")
          end
        end
      end
    end

    context "when user requests to re-send TOTP email" do
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

    context "when user chooses app as the 2FA method" do
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

    context "when user completes app-based 2FA setup using a valid code" do
      before do
        choose "app"
        click_on "Continue"

        fill_in :code, with: correct_totp_code
        click_on "Complete setup"
      end

      it "authenticates the user" do
        expect(@user.reload.totp_enabled?).to be true
      end

      it "shows a success message" do
        expect(page).to have_content("Two factor authentication setup successful")
      end

      it "redirects the user to the admin app" do
        expect(page).to have_current_path(new_organisation_setup_instructions_path)
      end

      it "asks for the app 2FA method when user logs in again" do
        click_on "Sign out"

        sign_in_user(@user, pass_through_two_factor: false)
        visit root_path

        expect(page).to have_content("Please enter your 6 digit two factor authentication code.")
        expect(page).to have_button("Authenticate")
      end

      it "does not send an email" do
        expect(notification_instance).to_not have_received(:send_email)
      end

      context "The user signs out and back in again" do
        before do
          click_on "Sign out"
          visit root_path

          fill_in "Email", with: "tom@gov.uk"
          fill_in "Password", with: correct_password
          click_on "Continue"
        end

        context "The user uses the correct code" do
          before :each do
            fill_in :code, with: correct_totp_code
            click_on "Authenticate"
          end

          it "Authenticates the user and redirects to the new organisation setup instructions" do
            expect(page).to have_current_path(Rails.application.routes.url_helpers.new_organisation_setup_instructions_path)
            expect(page).to have_content("Memorandum of understanding")
          end
        end

        context "The user uses an incorrect code" do
          before :each do
            fill_in :code, with: incorrect_totp_code
            click_on "Authenticate"
          end

          it "Re-renders the authentication page" do
            expect(page).to have_content("Please enter your 6 digit two factor authentication code.")
          end
        end
      end
    end

    context "when user completes app-based 2FA setup using an invalid code" do
      before do
        choose "app"
        click_on "Continue"
        @qr_code = page.find("img")["src"]
        fill_in :code, with: incorrect_totp_code
        click_on "Complete setup"
      end

      it "returns an error" do
        expect(page).to have_content("Six digit code is not valid")
      end

      it "returns to the 2FA screen" do
        expect(page).to have_content("Scan the QR code")
      end

      it "doesn't store a totp for the user" do
        expect(@user.otp_secret_key).to be nil
      end

      it "does not send an email" do
        expect(notification_instance).to_not have_received(:send_email)
      end

      it "retains the qr code" do
        expect(page.find("img")["src"]).to eq(@qr_code)
      end
    end
  end

  context "the user has no organisation" do
    before :each do
      @user = create(:user,
                     email: "tom@gov.uk",
                     password: correct_password,
                     name: "tom",
                     organisations: [])
      @user.confirm

      visit root_path

      fill_in "Email", with: "tom@gov.uk"
      fill_in "Password", with: correct_password

      click_on "Continue"

      visit root_path
    end

    it "presents the setup page" do
      expect(page).to have_current_path("/users/two_factor_authentication/setup")
    end

    context "continues with the setup process" do
      before :each do
        choose "app"
        click_on "Continue"

        fill_in :code, with: correct_totp_code
        click_on "Complete setup"
      end

      it "redirects to the new help page" do
        expect(page).to have_current_path("/help/new/signed_in")
      end
    end
  end
end
