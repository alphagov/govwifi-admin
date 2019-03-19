describe 'View authentication requests for a location', focus: true do
  context 'when signed in' do
    let(:user) { create(:user, organisation: organisation) }
    let(:organisation) { create(:organisation, :with_locations) }
    let(:location) { organisation.locations.first }

    before do
      sign_in_user user
      visit new_logs_search_path
      choose 'Location'
      click_on 'Go to search'
    end

    context 'With a new set of locations' do
      let(:location_2) { create(:location, address: "Abbey Street", postcode: "HA7 2BL") }
      let(:location_3) { create(:location, address: "Zeon Grove", postcode: "HA7 3BL") }
      let(:location_4) { create(:location, address: "Garry Road", postcode: "HA7 4BL") }

      let!(:organisation) { create(:organisation, locations: [location_2, location_3, location_4]) }

      it 'shows me the locations in alpabetical order' do
        locations = find('#logs_search_term').all('option').collect(&:text)
        expect(locations).to match_array ["Abbey Street, HA7 2BL", "Garry Road, HA7 4BL", "Zeon Grove, HA7 3BL"]
      end
    end

    it 'shows me my locations' do
      organisation.locations.each do |location|
        expect(page).to have_content(location.full_address)
      end
    end

    context 'choosing a location with no logs' do
      before do
        select location.address, from: "Select one of your organisation's locations"
        click_on 'Show logs'
      end

      it 'displays the no results message' do
        expect(page).to have_content("Traffic from #{location.address}"\
          " isn't reaching the GovWifi service")
      end
    end

    context 'choosing a location with logs' do
      let(:ip) { create(:ip, location: location) }
      let(:other_ip) { create(:ip) }

      before do
        Session.create!(
          start: 3.days.ago,
          username: 'aaaaa',
          mac: '',
          ap: '',
          siteIP: ip.address,
          success: true,
          building_identifier: ''
        )

        Session.create!(
          start: 3.days.ago,
          username: 'bbbbb',
          mac: '',
          ap: '',
          siteIP: other_ip.address,
          success: true,
          building_identifier: ''
        )

        select location.address, from: "Select one of your organisation's locations"
        click_on 'Show logs'
      end

      it 'displays logs for IPs under that location' do
        expect(page).to have_content(ip.address)
        expect(page).to have_content('aaaaa')
      end

      it 'does not display logs for other IPs' do
        expect(page).to_not have_content(other_ip.address)
        expect(page).to_not have_content('bbbbb')
      end
    end
  end
end
