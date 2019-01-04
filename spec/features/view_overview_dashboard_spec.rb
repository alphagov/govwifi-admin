describe 'viewing the overview dashboard' do
  include_context 'with a mocked notifications client'

  context 'when logged in' do
    let(:user) { create(:user) }

    context 'with no IPs' do
      before do
        sign_in_user user
        visit root_path
      end

      it 'redirects the user to the setting up page' do
        expect(page.current_path).to eq(setup_index_path)
      end

      it 'does not show overview in the navigation' do
        expect(page).to_not have_link('Overview')
      end
    end

    context 'with at least one IP' do
      let(:ip_one) { '10.0.0.1' }
      let(:ip_two) { '10.0.0.2' }
      let(:address_one) { '179 Southern Street, Southwark' }
      let(:postcode_one) { 'SE4 4BK' }
      let(:radius_secret_key) { 'E1EAB12AD10B8' }

      before do
        location_one = create(:location,
          organisation: user.organisation,
          address: address_one,
          postcode: postcode_one)

        location_one.update(radius_secret_key: radius_secret_key)

        create(:ip, address: ip_one, location: location_one)
        create(:ip, address: ip_two, location: location_one)

        sign_in_user user
        visit root_path
      end

      it 'shows the dashboard' do
        expect(page).to have_link("Admins")
        expect(page).to have_content("Locations")
        expect(page).to have_link("Added IPs")
      end

      it 'redirects to the team members page when Admins is clicked on' do
        click_link 'Admins'

        expect(page.current_path).to eq(team_members_path)
      end

      it 'redirects to the IPs page when Added IPs is clicked on' do
        click_link 'Added IPs'

        expect(page.current_path).to eq(ips_path)
      end
    end
  end
end
