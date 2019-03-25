describe 'View authentication requests for an IP', type: :feature do
  let(:ip) { '1.2.3.4' }
  let(:username) { 'ABCDEF' }

  let(:admin_user) { create(:user, organisation_id: organisation.id) }
  let(:organisation) { create(:organisation) }
  let(:location) { create(:location, organisation_id: organisation.id) }

  let(:other_user) { create(:user, organisation_id: other_user_organisation.id) }
  let(:other_user_organisation) { create(:organisation) }
  let(:other_user_location) { create(:location, organisation_id: other_user_organisation.id) }

  let(:super_admin) { create(:user, super_admin: true) }
  let(:super_admin_organisation) { create(:organisation) }
  let(:super_admin_location) { create(:location, super_admin_organisation: super_admin.organisation) }

  before do
    Session.create!(
      start: 3.days.ago,
      username: username,
      siteIP: ip,
      success: true
    )

    Session.create!(
      start: 3.days.ago,
      username: username,
      siteIP: ip,
      success: true
    )

    Session.create!(
      start: 3.days.ago,
      username: username,
      siteIP: ip,
      success: true
    )

    create(:ip, location_id: location.id, address: ip)

    sign_in_user super_admin
  end

  context 'when searching for an IP address' do
    before do
      visit ip_new_logs_search_path
      fill_in "IP address", with: search_string
      click_on "Show logs"
    end

    context "with a correct IP" do
      let(:search_string) { ip }

      it 'displays all results for the searched IP' do
        expect(page).to have_content("Found 3 results for \"#{ip}\"")
      end
    end

    context 'when a user from another organisation views an IP from another organisation' do
      let(:search_string) { ip }

      before do
        sign_in_user other_user
        visit ip_new_logs_search_path
        fill_in "IP address", with: search_string
        click_on "Show logs"
      end

      it 'displays all results for the searched IP' do
        expect(page).not_to have_content("Found 3 results for \"#{ip}\"")
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
