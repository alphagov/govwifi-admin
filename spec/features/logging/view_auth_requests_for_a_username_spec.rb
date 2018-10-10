require 'features/support/sign_up_helpers'

describe "View authentication requests for a username" do
  context "with results" do
    let(:username) { "AAAAAA" }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, :confirmed, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }
    let(:ip) { create(:ip, location_id: location.id, address: "1.1.1.1" )}
    let(:logs) do
      [
        {
          "ap" => "",
          "building_identifier" => "",
          "id" => 1,
          "mac" => "",
          "siteIP" => "1.1.1.1",
          "start" => "2018-10-01 18:18:09 +0000",
          "stop" => nil,
          "success" => true,
          "username" => username
        },
        {
          "ap" => "",
          "building_identifier" => "",
          "id" => 1,
          "mac" => "",
          "siteIP" => "1.1.1.1",
          "start" => "2018-10-01 18:18:09 +0000",
          "stop" => nil,
          "success" => true,
          "username" => username
        },
        {
          "ap" => "",
          "building_identifier" => "",
          "id" => 1,
          "mac" => "",
          "siteIP" => "2.2.2.2",
          "start" => "2018-10-01 18:18:09 +0000",
          "stop" => nil,
          "success" => true,
          "username" => username
        }
      ]
    end

    before do
      endpoint = ENV['LOGGING_API_SEARCH_ENDPOINT'] + username
      stub_request(:get, endpoint)
        .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host' => 'govwifi-logging-api.gov.uk',
            'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: logs.to_json, headers: {})

      sign_in_user admin_user
      visit search_logs_path
      fill_in "username", with: username
      click_on "Submit"
    end

    it "displays the authentication requests" do
      expect(page).to have_content("Displaying logs for #{username}")
    end

    it "displays the logs of the ips owned by the organisation location" do
      expect(page).to have_content("1.1.1.1")
    end

    it "does not display the logs of the ip the organisation does not own" do
      expect(page).to_not have_content("2.2.2.2")
    end
  end

  context "without results" do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    before do
      sign_in_user admin_user
      visit search_logs_path
      fill_in "username", with: ""
      click_on "Submit"
    end

    it "displays the no results message" do
      expect(page).to have_content("No results found for that username, please try again")
    end
  end
end
