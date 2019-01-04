describe 'View IP addresses' do
  include_context 'with a mocked notifications client'

  context 'when logged out' do
    before { visit ips_path }

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    context 'with no IPs' do
      before do
        sign_in_user user
      end

      it 'shows no IPs' do
        visit ips_path
        expect(page).to have_content 'Add IP'
        expect(page).to have_content 'You need to add the IPs of your authenticator(s)'
      end

      it 'redirects the user to the setting up page' do
        visit root_path
        expect(page.current_path).to eq(setup_index_path)
      end
    end

    context 'with IPs' do
      let(:ip_one) { '10.0.0.1' }
      let(:ip_two) { '10.0.0.2' }
      let(:address_one) { '179 Southern Street, Southwark' }
      let(:address_two) { '123 Northern Street, Whitechapel' }
      let(:postcode_one) { 'SE4 4BK' }
      let(:postcode_two) { 'NE7 3UP' }
      let(:radius_secret_key) { 'E1EAB12AD10B8' }

      before do
        location_one = create(:location,
          organisation: user.organisation,
          address: address_one,
          postcode: postcode_one)

        location_one.update(radius_secret_key: radius_secret_key)

        location_two = create(:location,
          organisation: user.organisation,
          address: address_two,
          postcode: postcode_two)

        create(:ip, address: ip_one, location: location_one)
        create(:ip, address: ip_two, location: location_two)

        sign_in_user user
        visit ips_path
      end

      it 'shows the RADIUS secret key' do
        expect(page).to have_content(radius_secret_key)
      end

      it 'shows those IPs' do
        expect(page).to have_content(ip_one)
        expect(page).to have_content(ip_two)
      end

      it 'shows the related addresses' do
        expect(page).to have_content(address_one)
        expect(page).to have_content(address_two)
      end

      it 'shows the related postcodes' do
        expect(page).to have_content(postcode_one)
        expect(page).to have_content(postcode_two)
      end
    end
  end
end
