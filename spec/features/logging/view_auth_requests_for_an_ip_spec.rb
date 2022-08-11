describe "View authentication requests for an IP", type: :feature do
  let!(:user) { create(:user) }
  let!(:organisation_one) { create(:organisation, :with_location_and_ip, users: [user]) }
  let!(:organisation_two) { create(:organisation, :with_location_and_ip, users: [user]) }
  let(:ip_one) { organisation_one.ip_addresses.first }
  let(:ip_two) { organisation_two.ip_addresses.first }

  before do
    create(:session, username: "Aaaaaa", siteIP: ip_one)
    create(:session, username: "Aaaaaa", siteIP: ip_two)
    create(:session, username: "aaabbb", siteIP: "9.9.9.9")
    sign_in_user user
  end

  context "when using a link" do
    before do
      visit ips_path

      within(:xpath, "//tr[th[normalize-space(text())=\"#{ip_one}\"]]") do
        click_on "View logs"
      end
    end

    it "displays the authentication requests" do
      expect(page).to have_content("Found 1 result for IP: \"#{ip_one}\"")
    end
  end

  context "when searching for an IP address" do
    before do
      visit new_logs_search_path
      choose "IP address"
      fill_in "Enter IP address", with: search_string
      click_on "Show logs"
    end

    context "with a correct IP" do
      let(:search_string) { ip_one }

      it "displays the authentication requests" do
        expect(page).to have_content("Found 1 result for IP: \"#{ip_one}\"")
      end

      it "has hyperlinks for username" do
        click_on "Aaaaaa"
        expect(page).to have_content("for username: \"Aaaaaa\"")
      end
    end

    context "with an IP that is not part of the current organisation" do
      let(:search_string) { ip_two }

      it "shows there are no results" do
        expect(page).to have_content("Traffic from #{ip_two} is not reaching the GovWifi service")
      end
    end

    context "with an incorrect IP" do
      let(:search_string) { "1" }

      it_behaves_like "errors in form"

      it "displays an error summary" do
        expect(page).to have_content("Search term must be a valid IP address").twice
      end
    end

    context "as a super admin" do
      let(:user) { create(:user, :super_admin) }
      let(:search_string) { "9.9.9.9" }

      it "finds log entries for ip addresses regardless of the current organisation" do
        expect(page).to have_content("Found 1 result for IP: \"9.9.9.9\"")
      end
    end
  end
end
