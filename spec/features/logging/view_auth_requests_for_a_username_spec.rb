describe "View authentication requests for a username", type: :feature do
  context "when an organisation with no ips searches logs" do
    let(:organisation_with_no_ips) { create(:organisation) }
    let(:admin_user) { create(:user, organisations: [organisation_with_no_ips]) }
    let(:username) { "AAAAAA" }

    before do
      sign_in_user admin_user
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "displays no results" do
      expect(page).to have_content("\"#{username}\" is not reaching the GovWifi service")
    end
  end

  context "with results" do
    let(:username) { "AAAAAA" }
    let(:admin_user) { create(:user, :with_organisation) }
    let(:location) { create(:location, organisation: admin_user.organisations.first) }

    before do
      create(:session, start: 3.days.ago, username: username, siteIP: "1.1.1.1", success: true)
      create(:session, start: 3.days.ago, username: username, siteIP: "1.1.1.1", success: false)
      create(:session, start: 3.days.ago, username: username, siteIP: "2.2.2.2", success: false)

      another_org = create(:organisation)
      another_org_location = create(:location, organisation: another_org)

      create(:ip, location_id: location.id, address: "1.1.1.1")
      create(:ip, location: another_org_location, address: "2.2.2.2")

      sign_in_user admin_user
      visit username_new_logs_search_path
      fill_in "Username", with: search_string
      click_on "Show logs"
    end

    context "when username is correct" do
      let(:search_string) { "AAAAAA" }

      it "displays two results" do
        expect(page).to have_content("Found 2 results for \"#{username}\"")
      end

      it "displays a successful request" do
        expect(page).to have_content("successful")
      end

      it "displays a failed request" do
        expect(page).to have_content("failed")
      end

      it "displays the logs of the ip" do
        expect(page).to have_content("1.1.1.1")
      end

      it "does not display the logs of the ip the organisation does not own" do
        expect(page).not_to have_content("2.2.2.2")
      end
    end

    context "when search input has trailing whitespace" do
      let(:search_string) { "AAAAAA " }

      it "displays the search results of the username" do
        expect(page).to have_content("1.1.1.1")
      end
    end

    context "when search input has leading whitespace" do
      let(:search_string) { " AAAAAA" }

      it "displays the search results of the username" do
        expect(page).to have_content("1.1.1.1")
      end
    end

    context "when username is too short" do
      let(:search_string) { "1" }

      it_behaves_like "errors in form"

      it "displays an error to the user" do
        expect(page).to have_content("Search term must be 5 or 6 characters")
      end
    end
  end

  context "without results" do
    let(:username) { "random" }

    before do
      sign_in_user create(:user, :with_organisation)
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "displays the no results message" do
      expect(page).to have_content("\"#{username}\" is not reaching the GovWifi service")
    end
  end
end
