describe "View authentication requests for a username" do
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

      it "displays the authentication requests" do
        expect(page).to have_content("Found 2 results for \"#{username}\"")
        expect(page).to have_content("successful")
        expect(page).to have_content("failed")
      end

      it "displays the logs of the ip" do
        expect(page).to have_content("1.1.1.1")
      end

      it "does not display the logs of the ip the organisation does not own" do
        expect(page).to_not have_content("2.2.2.2")
      end
    end

    context "When search input has whitespace" do
      let(:username) { "Garry" }

      context "with trailing whitespace" do
        let(:search_string) { "Garry " }

        it "displays the search results of the username after stripping its trailing whitespace" do
          expect(page).to have_content("1.1.1.1")
        end
      end

      context "with leading whitespace" do
        let(:search_string) { " Garry" }

        it "displays the search results of the username after stripping its leading whitespace" do
          expect(page).to have_content("1.1.1.1")
        end
      end
    end


    context "when username is too short" do
      let(:search_string) { "1" }

      it_behaves_like "errors in form"

      it "should display an error summary to the user" do
        expect(page).to have_content("Search term must be 5 or 6 characters")
        expect(page).to have_content("Please enter a valid username")
      end
    end
  end

  context "without results" do
    let(:username) { "random" }

    before do
      sign_in_user create(:user)
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
      fill_in "Username", with: username
      click_on "Show logs"
    end

    it "displays the no results message" do
      expect(page).to have_content("\"#{username}\" isn't reaching the GovWifi service")
    end
  end
end
