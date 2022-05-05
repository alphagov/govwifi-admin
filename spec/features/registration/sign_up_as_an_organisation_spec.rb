describe "Sign up as an organisation", type: :feature do
  let(:name) { "Sally" }
  let(:email_gateway) { EmailGatewaySpy.new }

  before do
    allow(Services).to receive(:email_gateway).and_return(email_gateway)

    Rails.application.config.s3_aws_config = {
      stub_responses: {
        get_object: { body: "#{SIGNUP_WHITELIST_PREFIX_MATCHER}(gov\\.uk)$" },
      },
    }
  end

  after { Warden.test_reset! }

  context "with a valid email" do
    let(:email) { "newuser@gov.uk" }

    before { sign_up_for_account(email:) }

    it "instructs the user to check their confirmation email" do
      expect(page).to have_content(
        "A confirmation email has been sent to your email address.",
      )
    end
  end

  context "with correct data" do
    before do
      sign_up_for_account(email:)
      update_user_details(name:)
    end

    context "with a gov.uk email" do
      let(:email) { "someone@gov.uk" }

      before do
        skip_two_factor_authentication
      end

      it "signs me in" do
        expect(page).to have_content "Sign out"
      end

      it "creates a confirmed membership joining the user to the org" do
        user = User.find_by(email:)
        organisation = Organisation.find_by(name: "Gov Org 1")
        expect(user.membership_for(organisation)).to be_confirmed
      end
    end

    context "with a email from a subdomain of gov.uk" do
      let(:email) { "someone@other.gov.uk" }

      before do
        skip_two_factor_authentication
      end

      it "signs me in" do
        expect(page).to have_content "Sign out"
      end
    end

    context "with a non-gov email" do
      let(:email) { "someone@google.com" }

      it "tells me my email is not valid" do
        expect(page).to have_content("Email address must be from a government or a public sector domain. If you're having trouble signing up, contact us.")
      end
    end

    context "with a blank email" do
      let(:email) { "" }

      it "tells me my email is not valid" do
        expect(page).to have_content("Email address must be from a government or a public sector domain. If you're having trouble signing up, contact us.")
      end
    end

    context "without a name" do
      let(:name) { "" }
      let(:email) { "someone@other.gov.uk" }

      it "tells me my name is not valid" do
        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  context "when password is too short" do
    before do
      sign_up_for_account
      update_user_details(password: "1")
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "tells the user that the password is too short" do
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end
  end

  context "without a password" do
    let(:email) { "someone@gov.uk" }

    before do
      sign_up_for_account
      update_user_details(password: "")
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "tells me my password is not valid" do
      expect(page).to have_content("Password can't be blank")
    end
  end

  context "when service email is not filled in" do
    before do
      sign_up_for_account
      update_user_details(service_email: "")
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "tells the user that the service email must be present" do
      expect(page).to have_content "Service email must be in the correct format, like name@example.com"
    end
  end

  context "when service email entered is not an email address" do
    before do
      sign_up_for_account
      update_user_details(service_email: "InvalidEmail")
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "tells the user that the service email must be a valid email address" do
      expect(page).to have_content "Service email must be in the correct format, like name@example.com"
    end
  end

  context "when password is too short" do
    before do
      sign_up_for_account
      update_user_details(password: "1")
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "tells the user that the password is too short" do
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end
  end

  context "when account is already confirmed" do
    before do
      sign_up_for_account
      update_user_details
      skip_two_factor_authentication
      visit confirmation_email_link
    end

    it_behaves_like "errors in form"

    it "tells the user the email is already confirmed" do
      expect(page).to have_content "Email was already confirmed"
    end
  end

  context "when an organisation is already registered" do
    let(:existing_org_name) { "Gov Org 1" }

    before do
      sign_up_for_account
      create(:organisation, name: existing_org_name)
      update_user_details(organisation_name: existing_org_name)
      skip_two_factor_authentication
    end

    it_behaves_like "errors in form"

    it "shows the user an error message" do
      within("div.govuk-error-summary") do
        expect(page).to have_content("Name is already registered")
      end
    end
  end

  context "with an already registered email" do
    let(:email) { "george@gov.uk" }

    before { sign_up_for_account(email:) }

    it "will tell the user the email is already in use" do
      sign_up_for_account(email:)
      expect(page).to have_content("This email address is already associated with an account. If you can't sign in, reset your password")
    end
  end

  context "when no organisation has been selected" do
    let(:org_name_left_blank) { "" }

    before { sign_up_for_account }

    it "displays one error message that the name cannot be left blank" do
      update_user_details(organisation_name: org_name_left_blank)
      skip_two_factor_authentication
      within("div.govuk-error-summary") do
        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  context "when creating a new organisation" do
    let(:whitelist_gateway) { instance_double(Gateways::S3, read: "#{SIGNUP_WHITELIST_PREFIX_MATCHER}(gov\\.uk)$") }
    let(:organisation_names_gateway) { instance_spy(Gateways::S3) }
    let(:data) { instance_double(StringIO) }
    let(:presenter) { instance_double(UseCases::Administrator::FormatOrganisationNames) }

    before do
      allow(Gateways::S3).to receive(:new).and_return(whitelist_gateway, organisation_names_gateway)
      allow(UseCases::Administrator::FormatOrganisationNames).to receive(:new).and_return(presenter)
      allow(presenter).to receive(:execute).and_return(data)

      sign_up_for_account
      update_user_details(organisation_name: "Org 1")
      skip_two_factor_authentication
    end

    it "publishes the updated list of organisation names to S3" do
      expect(organisation_names_gateway).to have_received(:write).with(data:)
    end
  end
end
