describe 'Tracking a new organisation conversion pathway', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
    visit root_path
  end

  it 'redirects the user to the new organisation setup path' do
    expect(page).to have_current_path(new_organisation_setup_instructions_path)
  end

  context 'when a new organisation visits the IPs page' do
    before { click_on 'IPs' }

    it 'displays new org in the URL' do
      expect(page).to have_current_path('/ips/new_org')
    end

    context 'when a new organisation clicks on the add_IP_address button' do
      before { click_on 'Add IP address' }

      it 'displays new org in the URL' do
        expect(page).to have_current_path('/locations/new_org')
      end
    end

    context 'when a new organisation adds a location with no IPs' do
      before do
        click_on 'Add IP address'
        fill_in 'Address', with: '100 Triangle'
        fill_in 'Postcode', with: 'W1A 2AB'
        click_on 'Add new location'
      end

      it 'displays new org in the URL' do
        expect(page).to have_current_path('/ips/created/location/new_org')
      end
    end

    context 'when a new organisation adds their first IP to a selected location' do
      let(:ip_address) { '141.0.149.130' }
      let!(:location) { create(:location, organisation: user.organisation) }

      before do
        visit new_org_ips_path
        click_on 'Add IP to this location'
      end

      it 'displays new org in the URL' do
        expect(page).to have_current_path(new_org_new_ip_path(location: location))
      end

      it 'displays new org in the URL when first IP is added' do
        fill_in 'address', with: ip_address
        click_on 'Add new IP address'

        expect(page).to have_current_path('/ips/created/new_org')
      end
    end

    context 'when a new organisation adds their first location with IPs' do
      let(:ip_input) { "location_ips_attributes_0_address" }

      before do
        visit new_org_locations_path
        fill_in 'Address', with: '100 Triangle'
        fill_in 'Postcode', with: 'W1A 2AB'
        fill_in ip_input, with: '141.0.149.130'
        click_on 'Add new location'
      end

      it 'displays new org in the URL' do
        expect(page).to have_current_path('/ips/created/location/with-ip/new_org')
      end
    end
  end
end
