describe 'View authentication requests for an IP', type: :feature do
  let(:user) { create(:user, organisation: user_organisation) }
  let(:user_organisation) { create(:organisation) }
  let(:user_location) { create(:location, organisation: user.organisation) }

  let(:user_2) { create(:user, organisation: user_2_organisation) }
  let(:user_2_organisation) { create(:organisation) }
  let(:user_2_location) { create(:location, organisation: user_2.organisation) }

  let(:super_admin) { create(:user, super_admin: true) }
  let(:super_admin_organisation) { create(:organisation) }
  let(:super_admin_location) { create(:location, organisation: super_admin.organisation) }

  let(:ip_1) { create(:ip, location_id: user_location.id, address: '1.2.3.4') }
  let(:ip_2) { create(:ip, location_id: user_2_location.id, address: '1.2.3.5') }

  before do
    Session.create!(
      start: 3.days.ago,
      siteIP: ip_1.address,
    )

    Session.create!(
      start: 3.days.ago,
      siteIP: ip_1.address,
    )

    Session.create!(
      start: 3.days.ago,
      siteIP: ip_2.address,
    )

    Session.create!(
      start: 3.days.ago,
      siteIP: ip_2.address,
    )

    sign_in_user super_admin
  end

  context 'when searching for an IP address' do
    before do
      visit ip_new_logs_search_path
      fill_in "IP address", with: search_string
      click_on "Show logs"
    end

    context "with a correct IP from another organisation" do
      let(:search_string) { ip_1.address }

      it 'displays all results for that searched IP' do
        expect(page).to have_content("Found 2 results for \"#{ip_1.address}\"")
      end
    end

    context "when entering an IP address that belongs to another organisation" do
      let(:search_string) { ip_2.address }

      before do
        sign_in_user user
        visit ip_new_logs_search_path
        fill_in "IP address", with: search_string
        click_on "Show logs"
      end

      it "does not display any logs" do
        expect(page).not_to have_content("Found 2 results for \"#{ip_2.address}\"")
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
