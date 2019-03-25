describe "View authentication requests for a username", focus: true, type: :feature do
  context "with results" do
    let(:username) { "AAAAAA" }
    let(:search_string) { "AAAAAA" }

    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: "1.1.1.1",
        success: true,
        building_identifier: ""
      )

      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: "1.1.1.1",
        success: false,
        building_identifier: ""
      )

      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: "2.2.2.2",
        success: false,
        building_identifier: ""
      )

      organisation = create(:organisation)
      location_two = create(:location, organisation: organisation)

      create(:ip, location_id: location.id, address: "1.1.1.1")
      create(:ip, location: location_two, address: "2.2.2.2")

      sign_in_user admin_user
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
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

      it "prompts the user for a valid username" do
        expect(page).to have_content("Enter a valid username")
      end
    end
  end

  context "without results" do
    let(:organisation) { create(:organisation) }
    let(:admin_user_2) { create(:user, organisation_id: organisation.id) }
    let(:username) { "AAAAAA" }

    before do
      sign_in_user admin_user_2
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it 'wont allow an organsiation with no ips to view all logs' do
      expect(page).to have_content("\"#{username}\" isn't reaching the GovWifi service")
    end

    it "displays the no results message" do
      expect(page).to have_content("\"#{username}\" isn't reaching the GovWifi service")
    end
  end
end
