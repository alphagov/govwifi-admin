describe "View authentication requests for a username", focus: true, type: :feature do

  context "with super admin privileages" do
    let(:username) { "Larry" }

    let!(:super_admin) { create(:user, super_admin: true) }
    let(:super_admin_location) { create(:location, organisation: super_admin.organisation) }
    let!(:super_admin_ip) { create(:ip, location: super_admin_location) }

    let(:organisation) { create(:organisation) }
    let(:location) { create(:location, organisation: organisation) }
    let!(:ip) { create(:ip, location: location) }

    let(:organisation_2) { create(:organisation) }
    let(:location_2) { create(:location, organisation: organisation_2) }
    let!(:ip_2) { create(:ip, location: location_2) }


    before do
      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: super_admin_ip.address,
        success: true,
        building_identifier: ""
      )
      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: ip.address,
        success: true,
        building_identifier: ""
      )

      Session.create!(
        start: 3.days.ago,
        username: username,
        mac: "",
        ap: "",
        siteIP: ip_2.address,
        success: true,
        building_identifier: ""
      )

      sign_in_user super_admin
      visit new_logs_search_path
      choose "Username"
      click_on "Go to search"
      fill_in "Username", with: username
      click_on "Show logs"
    end

    context "when username is correct" do
      it "displays three results" do
        expect(page).to have_content("Found 3 results for \"#{username}\"")
      end
    end
  end
end
