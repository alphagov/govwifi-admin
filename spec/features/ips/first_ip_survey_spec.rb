describe "Sending a survey when adding the first IP to an organisation", type: :feature do
  let(:sent_first_ip_survey) { true }
  let(:user) { create(:user, :with_organisation, sent_first_ip_survey:) }
  let(:organisation) { user.organisations.first }
  let(:location) { create(:location, organisation:) }
  let!(:another_administrator) { create(:user, organisations: [user.organisations.first]) } # a minimium of two administrators are now required to add IP addresses
  let(:notify_gateway) { spy }
  before do
    allow(Services).to receive(:notify_gateway).and_return(notify_gateway)
    allow(notify_gateway).to receive(:send_email)
    sign_in_user user
    visit location_add_ips_path(location_id: location.id)
    fill_in "location_ips_form[ip_1]", with: "1.1.1.1"
  end

  describe "The user has had a survey sent already" do
    it "does not send a survey" do
      click_on "Add IP addresses"
      expect(notify_gateway).to_not have_received(:send_email)
    end
  end

  describe "The user has not had a survey sent already" do
    let(:sent_first_ip_survey) { false }
    it "sends a survey" do
      click_on "Add IP addresses"
      expect(notify_gateway).to have_received(:send_email).with({ email_address: user.email,
                                                                  personalisation: {},
                                                                  template_id: "first_ip_survey_template",
                                                                  reference: "first_ip_survey" })
    end
    it "sets the sent_first_ip_survey flag" do
      expect {
        click_on "Add IP addresses"
      }.to change { user.reload.sent_first_ip_survey }.from(false).to(true)
    end
    context "The current organisation has Ip addresses" do
      before :each do
        create(:ip, location:)
      end
      it "does not send a survey" do
        expect {
          click_on "Add IP addresses"
        }.to_not(change { user.reload.sent_first_ip_survey })
        expect(notify_gateway).to_not have_received(:send_email)
      end
    end
  end
end
