describe 'Adding an IP to an existing location', type: :feature do
  let(:location) { create(:location, organisation: user.organisation) }
  let(:user) { create(:user) }

  context 'when selecting a location' do
    before do
      sign_in_user user
      visit new_ip_path(location: location)
      fill_in 'address', with: ip_address
      click_on 'Add new IP address'
    end

    context 'with valid data' do
      let(:ip_address) { '141.0.149.130' }

      it 'adds the IP' do
        expect(page).to have_content("141.0.149.130 added")
      end

      it 'adds to the correct location' do
        expect(location.reload.ips.map(&:address)).to include("141.0.149.130")
      end

      it 'redirects to the "after IP created" path for Analytics' do
        expect(page).to have_current_path('/ips/created')
      end
    end

    context 'with invalid data' do
      let(:ip_address) { '10.wrong.0.1' }

      it 'shows a error message' do
        expect(page).to have_content("'10.wrong.0.1' is not valid")
      end

      it 'does not add an IP to the location' do
        expect(location.reload.ips).to be_empty
      end
    end

    context 'with data as an IPv6 address' do
      let(:ip_address) { 'FE80::0202:B3FF:FE1E:8329' }

      it 'does not add an IP to the location' do
        expect(location.reload.ips).to be_empty
      end

      it 'shows an error message' do
        expect(page).to have_content("'FE80::0202:B3FF:FE1E:8329' is an IPv6 address. Only IPv4 addresses can be added")
      end
    end

    context 'with data as a private IP address' do
      let(:ip_address) { '192.168.0.0' }

      it 'does not add an IP to the location' do
        expect(location.reload.ips).to be_empty
      end

      it 'shows an error message' do
        expect(page).to have_content("'192.168.0.0' is a private IP address. Only public IPv4 addresses can be added.")
      end
    end
  end

  context 'when selecting another location' do
    let(:other_location) do
      create(:location, organisation: user.organisation)
    end

    before do
      sign_in_user user
      visit new_ip_path(location: other_location)
      fill_in 'address', with: "141.0.149.130"
      click_on 'Add new IP address'
    end

    it 'adds the IP' do
      expect(page).to have_content("141.0.149.130 added")
    end

    it 'adds to that location' do
      expect(other_location.reload.ips.map(&:address)).to include("141.0.149.130")
    end

    it 'redirects to the "after IP created" path for Analytics' do
      expect(page).to have_current_path('/ips/created')
    end
  end

  context 'when not logged in' do
    before do
      visit new_ip_path(location: location)
    end

    it_behaves_like 'not signed in'
  end
end
