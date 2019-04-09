describe 'Viewing IP addresses', type: :feature do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user) }

  context 'with no IPs' do
    before do
      sign_in_user user
    end

    it 'shows no IPs' do
      visit ips_path
      expect(page).to have_content 'You need to add the IPs of your authenticator(s)'
    end

    it 'redirects the user to the setting up page' do
      visit root_path

      within("h2") do
        expect(page).to have_content("Get GovWifi access in your organisation")
      end
    end
  end

  context 'with IPs' do
    let(:location_one) { create(:location, organisation: user.organisation) }
    let(:location_two) { create(:location, organisation: user.organisation) }
    let!(:ip_one) { create(:ip, location: location_one) }
    let!(:ip_two) { create(:ip, location: location_two) }

    before do
      sign_in_user user
      visit ips_path
    end

    it 'shows the RADIUS secret keys' do
      displayed_secret_keys = page.all("div#radius-secret-key").map(&:text)
      expect(displayed_secret_keys).to match_array([location_one.radius_secret_key, location_two.radius_secret_key])
    end

    it 'shows the IPs' do
      displayed_ips = page.all("td#ip-address").map(&:text)
      expect(displayed_ips).to match_array([ip_one.address, ip_two.address])
    end

    it 'shows the locations addresses' do
      location_addresses = page.all("span#location-address").map(&:text)
      expect(location_addresses).to match_array([location_one.full_address, location_two.full_address])
    end
  end

  context 'when logged out' do
    before { visit ips_path }

    it_behaves_like 'not signed in'
  end
end
