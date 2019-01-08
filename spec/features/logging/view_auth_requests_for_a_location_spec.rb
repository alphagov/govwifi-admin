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

      # TODO: session factory?
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

    # TODO: test going back
  end
end
