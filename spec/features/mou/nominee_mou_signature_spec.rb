describe "Nominated user signs the MOU", type: :feature do
  include EmailHelpers

  context "when a user follows the URL from their email containing the nomination token" do
    let(:token) { "tZPAY6puVsNpxkUE9sqZ" }
    let(:organisation) { create(:organisation) }
    let(:email_gateway) { spy }

    before do
      create(:nomination, nominated_user_name: "Maryan Khan", nominated_user_email: "Maryan.Khan@email.gov.uk", organisation:, nomination_token: token)
      visit nominee_form_for_mou_path(token:)
    end

    it "directs the user to the MOU form" do
      expect(page).to have_content("Read and Accept the Terms for GovWifi")
    end

    it "displays the organisation's terms and conditions for acceptance" do
      expect(page).to have_content("I confirm that I have the authority to accept these terms and that #{organisation.name} will be bound by them.")
    end

    context "when the user signs the MOU" do
      let(:email_gateway) { spy }

      before do
        allow(Services).to receive(:email_gateway).and_return(email_gateway)
        fill_in "Name", with: "Maryan Khan"
        fill_in "Email", with: "Maryan.Khan@email.gov.uk"
        fill_in "Job role", with: "HR"
        check "I confirm that I have the authority to accept these terms and that #{organisation.name} will be bound by them."
        click_button "Accept the MOU"
      end

      it "creates a signature for the MOU when terms are accepted" do
        expect(Mou.exists?(user: nil)).to be_truthy
      end

      it "sends a confirmation email upon MOU signature" do
        it_sent_a_thank_you_for_signing_the_mou_email_once
      end
    end

    it "does not create a MOU signature when fields are not filled in and terms are not accepted" do
      click_button "Accept the MOU"
      expect(Mou.exists?(user: nil)).to be_falsey
    end
  end
end
