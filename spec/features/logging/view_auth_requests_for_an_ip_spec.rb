describe 'View authentication requests for an IP' do
  context 'with results' do
    let(:ip) { '1.2.3.4' }
    let(:username) { 'ABCDEF' }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      Session.create!(
        start: 3.days.ago,
        username: username,
        siteIP: ip,
        success: true
      )

      create(:ip, location_id: location.id, address: ip)
      sign_in_user admin_user
    end

    context 'viewing logs of an IP address directly from link' do
      before do
        visit ips_path

        within('#ips-table') do
          click_on 'View logs'
        end
      end

      it 'displays the authentication requests' do
        expect(page).to have_content("Found 1 result for \"#{ip}\"")
        expect(page).to have_content(username)
      end
    end

    context 'viewing logs by searching for an IP address' do
      before do
        visit ip_new_logs_search_path
        fill_in "IP address", with: search_string
        click_on "Show logs"
      end

      context "when IP is correct" do
        let(:search_string) { ip }

        it 'displays the authentication requests' do
          expect(page).to have_content("Found 1 result for \"#{ip}\"")
          expect(page).to have_content(username)
        end
      end

      context "when IP is incorrect" do
        let(:search_string) { "1" }

        it_behaves_like "errors in form"

        it "should display an error summary and prompt to the user" do
          expect(page).to have_content("Search term must be a valid IP address")
          expect(page).to have_content("Please enter a valid IP address")
        end
      end
    end
  end
end
