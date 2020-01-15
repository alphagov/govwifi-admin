describe "A confirmed user with no organisation memberships logs in", type: :feature do
  let(:user) { create(:user, organisations: []) }

  context "with an existing confirmed user" do
    before do
      sign_in_user user
      visit root_path
    end

    it "redirects to the help path" do
      expect(page).to have_current_path(signed_in_new_help_path)
    end

    it "prints an instruction" do
      expect(page).to have_content("You do not belong to an organisation")
    end

    context "when the user selects a specific type of support" do
      let(:zendesk_client) { instance_double(Gateways::ZendeskSupportTickets) }

      before do
        allow(Gateways::ZendeskSupportTickets).to receive(:new)
          .and_return(zendesk_client)
        allow(zendesk_client).to receive(:create)
      end

      it "presents the user with a support request form" do
        expect(page).to have_content("Support")
      end

      it "allows the user to submit a support request" do
        fill_in "Tell us about your issue", with: "Help!"
        click_on "Send support request"

        expect(page).to have_http_status(200)
      end
    end
  end
end
