describe "View authentication requests for an IP", type: :feature do
  let(:super_admin) { create(:user, :super_admin) }
  let(:user_location) { create(:location) }
  let(:ip_1) { create(:ip, location: user_location, address: "1.2.3.4") }

  let(:user_2) { create(:user, :with_organisation) }
  let(:user_2_location) { create(:location, organisation: user_2.organisations.first) }
  let(:ip_2) { create(:ip, location: user_2_location, address: "1.2.3.5") }

  before do
    create(:session, siteIP: ip_1.address)
    create(:session, siteIP: ip_1.address)
    create(:session, siteIP: ip_2.address)
    create(:session, siteIP: ip_2.address)

    sign_in_user super_admin
    visit new_logs_search_path
    choose "IP address"
  end

  context "when searching for an IP" do
    before do
      fill_in "Enter IP address", with: ip_1.address
      click_on "Show logs"
    end

    it "displays all found results for that searched IP" do
      expect(page).to have_content("Found 2 results for IP: \"#{ip_1.address}\"")
    end
  end

  context "when searching for another IP" do
    before do
      fill_in "Enter IP address", with: ip_2.address
      click_on "Show logs"
    end

    it "displays all found results for that searched IP" do
      expect(page).to have_content("Found 2 results for IP: \"#{ip_2.address}\"")
    end
  end

  context "with an incorrect IP" do
    let(:search_string) { "1" }

    before do
      fill_in "Enter IP address", with: search_string
      click_on "Show logs"
    end

    it_behaves_like "errors in form"

    it "displays an error summary" do
      expect(page).to have_content("Enter an IP address in the correct format")
    end
  end
  context "with a valid IP address not associated with organisation" do
    let(:search_string) { "192.0.2.1" }

    before do
      fill_in "Enter IP address", with: search_string
      click_on "Show logs"
    end
    it "displays an error message for unassociated IP address" do
      expect(page).to have_content("Enter an IP address associated with your organisation")
    end
  end
end
