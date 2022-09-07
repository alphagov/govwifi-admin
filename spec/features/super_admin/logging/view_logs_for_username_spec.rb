describe "View authentication requests for a username", type: :feature do
  let(:username) { "Larry" }

  let(:super_admin) { create(:user, :super_admin) }

  let(:organisations) { create_list(:organisation, 3) }
  let(:locations) { organisations.map { |organisation| create(:location, organisation:) } }
  let(:ip) { locations.map { |location| create(:ip, location:) } }

  before do
    sign_in_user super_admin
    visit root_path

    visit new_logs_search_path
    choose "Username"
  end

  context "when there are results from multiple organisations and users" do
    before do
      create(:session, start: 3.days.ago, username:, siteIP: ip[0].address, success: true)
      create(:session, start: 3.days.ago, username:, siteIP: ip[1].address, success: true)
      create(:session, start: 3.days.ago, username:, siteIP: ip[2].address, success: true)
      create(:session, start: 3.days.ago, username: "user2", siteIP: ip[2].address, success: true)

      fill_in "Enter username", with: username
      click_on "Show logs"
    end

    it "displays all results for the searched user across multiple organisations" do
      expect(page).to have_content("Found 3 results for username: \"#{username}\"")
    end

    it "does not display results for other users" do
      expect(page).not_to have_content("user2")
    end
  end

  context "when no results exist" do
    before do
      fill_in "Enter username", with: username
      click_on "Show logs"
    end

    it "displays the no results message" do
      expect(page).to have_content("We have no record of username \"#{username}\" reaching the GovWifi service from your organisation in the last 2 weeks")
    end
  end

  context "when username is incorrect" do
    let(:username) { "1" }

    before do
      fill_in "Enter username", with: username
      click_on "Show logs"
    end

    it "prompts the user for a valid username" do
      expect(page).to have_content("Search term must be 5 or 6 characters").twice
    end
  end
end
