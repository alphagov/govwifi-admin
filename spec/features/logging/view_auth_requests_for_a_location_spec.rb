describe "View authentication requests for a location", type: :feature do
  let(:user) { create(:user, organisations: [organisation]) }
  let(:organisation) { create(:organisation, :with_locations) }
  let(:location) { organisation.locations.first }

  before do
    sign_in_user user
    visit new_logs_search_path
    choose "Location"
    click_on "Go to search"
  end

  context "when selecting a location to view logs for" do
    let(:location_2) { create(:location, address: "Abbey Street", postcode: "HA7 2BL") }
    let(:location_3) { create(:location, address: "Zeon Grove", postcode: "HA7 3BL") }
    let(:location_4) { create(:location, address: "Garry Road", postcode: "HA7 4BL") }
    let(:organisation) { create(:organisation, locations: [location_2, location_3, location_4]) }

    it "shows the organisations in alpabetical order" do
      locations = find("#logs-search-search-term-field").all("option").collect(&:text)
      expect(locations).to match_array ["Abbey Street, HA7 2BL", "Garry Road, HA7 4BL", "Zeon Grove, HA7 3BL"]
    end
  end

  context "when choosing a location with no logs" do
    before do
      select location.address, from: "Select one of your organisation's locations"
      click_on "Show logs"
    end

    it "displays the no results message" do
      expect(page).to have_content("Traffic from #{location.address}"\
        " is not reaching the GovWifi service")
    end
  end

  context "when choosing a location with logs" do
    let(:ip) { create(:ip, location: location) }
    let(:other_ip) { create(:ip) }

    before do
      create(:session, start: 3.days.ago, username: "aaaaa", siteIP: ip.address, success: true)
      create(:session, start: 3.days.ago, username: "bbbbb", siteIP: other_ip.address, success: true)

      select location.address, from: "Select one of your organisation's locations"
      click_on "Show logs"
    end

    it "displays logs for IPs under that location" do
      expect(page).to have_content(ip.address)
    end

    it "does not display logs for other IPs" do
      expect(page).not_to have_content(other_ip.address)
    end

    context "when going back to search by a different location" do
      before do
        click_on "Search by a different location"
        select location.address, from: "Select one of your organisation's locations"
        click_on "Show logs"
      end

      it "displays logs for IPs under that location" do
        expect(page).to have_content(ip.address)
      end

      it "does not display logs for other IPs" do
        expect(page).not_to have_content(other_ip.address)
      end
    end
  end
end
