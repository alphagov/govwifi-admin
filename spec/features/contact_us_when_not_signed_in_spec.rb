describe "Contact us when not signed in", type: :feature do
  include_context "with a mocked support tickets client"

  let(:email) { "george@gov.uk" }
  let(:name) { "George" }
  let(:details) { "I have an issue" }

  before do
    ENV["ZENDESK_API_ENDPOINT"] = "https://example-company.zendesk.com/api/v2/"
    ENV["ZENDESK_API_USER"] = "zd-api-user@example-company.co.uk"
    ENV["ZENDESK_API_TOKEN"] = "abcdefggfedcba"
    visit new_help_path
  end

  context "when navigating via links" do
    it "shows the user the not signed in support page" do
      expect(page).to have_content "How can we help?"
    end
  end

  context "when having trouble signing up" do
    before do
      choose "Setting up GovWifi in your organisation support"
      click_on "Continue"
      fill_in "Your email address", with: email
      fill_in "Tell us a bit more about your issue", with: details
      click_on "Submit"
    end

    it "submits the ticket" do
      expect(page).to have_content "Your support request has been submitted."
    end
  end

  context "when something is wrong with their admin account" do
    before do
      choose "Managing GovWifi in your organisation support"
      click_on "Continue"
      fill_in "Your email address", with: email
      fill_in "Tell us a bit more about your issue", with: details
    end

    it "submits the ticket" do
      click_on "Submit"
      expect(page).to have_content "Your support request has been submitted."
    end

    it "sends an email" do
      expect {
        click_on "Submit"
      }.to change(support_tickets, :count).by(1)
    end
  end

  context "when there is a question or feedback" do
    before do
      choose "Request GovWifi user information"
      click_on "Continue"
      fill_in "Your message", with: details
      fill_in "Your email address", with: email
    end

    it "submits the ticket" do
      click_on "Submit"
      expect(page).to have_content "Your support request has been submitted."
    end

    it "sends an email" do
      expect {
        click_on "Submit"
      }.to change(support_tickets, :count).by(1)
    end

    it "records the email" do
      click_on "Submit"
      expect(support_tickets.last[:requester][:email])
        .to eq email
    end
  end

  context "with an incorrectly filled out form" do
    before do
      visit technical_support_new_help_path
      fill_in "Your email address", with: email
      fill_in "Tell us a bit more about your issue", with: details
    end

    context "with blank details" do
      let(:details) { "" }

      before do
        click_on "Submit"
      end

      it "displays an error message" do
        expect(page).to have_content "Details can't be blank"
      end

      it "does not submit the form" do
        expect { click_on "Submit" }.not_to change(support_tickets, :count)
      end
    end

    context "with blank email" do
      let(:email) { "" }

      before do
        click_on "Submit"
      end

      it "displays an error message" do
        expect(page).to have_content "Email can't be blank"
      end

      it "does not submit the form" do
        expect { click_on "Submit" }.not_to change(support_tickets, :count)
      end
    end
  end

  context "with incorrect email formats" do
    before do
      visit technical_support_new_help_path
      fill_in "Your email address", with: email
      fill_in "Tell us a bit more about your issue", with: details
    end

    context "without a subdomain" do
      let(:email) { "test@" }

      before do
        click_on "Submit"
      end

      it "does not submit the form" do
        expect(page).to have_content "Email is not a valid email address"
      end
    end

    context "with random whitespace" do
      let(:email) { "test@ gov .uk" }

      before do
        click_on "Submit"
      end

      it "does not submit the form" do
        expect(page).to have_content "Email is not a valid email address"
      end
    end

    context "without an @ symbol" do
      let(:email) { "testgov.uk" }

      before do
        click_on "Submit"
      end

      it "does not submit the form" do
        expect(page).to have_content "Email is not a valid email address"
      end
    end

    context "correct but rejected by Zendesk" do
      let(:email) { "blah_blah%\#@\#$" }
      before do
        ZendeskClientMock.exception_to_raise = ZendeskAPI::Error::RecordInvalid.new({})
        click_on "Submit"
      end

      it "does not submit the form" do
        expect(page).to have_content "Email is not a valid email address"
      end
    end
  end
end

context "when navigating directly to root/help path" do
  before { visit "/help" }

  it "shows the user the not signed in support page" do
    expect(page).to have_content "How can we help?"
  end
end

context "when navigating directly to signed-in help path" do
  before { visit "/help/new/signed_in" }

  it "shows the user the not signed in support page" do
    expect(page).to have_content "How can we help?"
  end
end
