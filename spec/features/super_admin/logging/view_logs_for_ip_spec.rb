describe 'View authentication requests for an IP', focus: true, type: :feature do
  let(:ip) { '1.2.3.4' }
  let(:username) { 'ABCDEF' }

  let(:other_user) { create(:user, organisation: other_user_organisation) }
  let(:other_user_organisation) { create(:organisation) }
  let(:other_user_location) { create(:location, organisation: other_user.organisation) }

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

    create(:ip, location_id: super_admin_location.id, address: ip)

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

    context "when entering an IP address that belongs to another organisation" do
      let(:search_string) { ip }

      before do
        sign_in_user other_user
        visit ip_new_logs_search_path
        fill_in "IP address", with: search_string
        click_on "Show logs"
      end

      it "does not display any logs" do
        expect(page).not_to have_content("Found 3 results for \"#{ip}\"")
      end
    end

    context "with an incorrect IP" do
      let(:search_string) { "1" }

      it_behaves_like "errors in form"

      it "displays an error summary" do
        expect(page).to have_content("Search term must be a valid IP address")
      end
    end
  end
end
