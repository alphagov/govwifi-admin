describe "View authentication requests for a username", type: :feature do
  let(:username) { "Larry" }

  let(:super_admin) { create(:user, :super_admin) }
  let(:super_admin_location) { create(:location, organisation: super_admin.organisations.first) }
  let(:super_admin_ip) { create(:ip, location: super_admin_location) }

  let(:organisation) { create(:organisation) }
  let(:location) { create(:location, organisation:) }
  let(:ip) { create(:ip, location:) }

  let(:organisation_2) { create(:organisation) }
  let(:location_2) { create(:location, organisation: organisation_2) }
  let(:ip_2) { create(:ip, location: location_2) }

  before do
    sign_in_user super_admin
    visit new_logs_search_path
    choose "Username"
    click_on "Go to search"
  end

  context "when there are results from multiple organisations and users" do
    before do
      create(:session, start: 3.days.ago, username:, siteIP: super_admin_ip.address, success: true)
      create(:session, start: 3.days.ago, username:, siteIP: ip.address, success: true)
      create(:session, start: 3.days.ago, username:, siteIP: ip_2.address, success: true)
      create(:session, start: 3.days.ago, username: "user2", siteIP: ip_2.address, success: true)

      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "displays all results for the searched user across multiple organisations" do
      expect(page).to have_content("Found 3 results for \"#{username}\"")
    end

    it "does not display results for other users" do
      expect(page).not_to have_content("user2")
    end
  end

  context "when no results exist" do
    before do
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "displays the no results message" do
      expect(page).to have_content("\"#{username}\" is not reaching the GovWifi service")
    end
  end

  context "when username is incorrect" do
    let(:username) { "1" }

    before do
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "prompts the user for a valid username" do
      expect(page).to have_content("Enter a valid username")
    end
  end
end
