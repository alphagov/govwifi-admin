describe "View authentication requests for an IP", type: :feature do
  let(:ip) { "1.2.3.4" }
  let(:username) { "ABCDEF" }
  let(:admin_user) { create(:user, :with_organisation) }
  let(:location) { create(:location, organisation: admin_user.organisations.first) }

  before do
    create(:session, start: 3.days.ago, username: username, siteIP: ip, success: true)
    create(:ip, location_id: location.id, address: ip, created_at: 5.days.ago)
    sign_in_user admin_user
  end

  context "when using a link" do
    before do
      visit ips_path

      within(:xpath, "//tr[th[normalize-space(text())=\"#{ip}\"]]") do
        click_on "View logs"
      end
    end

    it "displays the authentication requests" do
      expect(page).to have_content("Found 1 result for \"#{ip}\"")
    end
  end

  context "when searching for an IP address" do
    before do
      visit ip_new_logs_search_path
      fill_in "IP address", with: search_string
      click_on "Show logs"
    end

    context "with a correct IP" do
      let(:search_string) { ip }

      it "displays the authentication requests" do
        expect(page).to have_content("Found 1 result for \"#{ip}\"")
      end
    end

    context "with an incorrect IP" do
      let(:search_string) { "1" }

      it_behaves_like "errors in form"

      it "displays an error summary" do
        expect(page).to have_content("Search term must be a valid IP address")
      end

      it "prompts to the user for a valid IP address" do
        expect(page).to have_content("Enter a valid IP address")
      end
    end
  end
end
