describe 'Add new location', type: :feature do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user) }
  let(:ip_input) { "location_ips_attributes_0_address" }
  let(:second_ip_input) { "location_ips_attributes_1_address" }

  before do
    sign_in_user user
    visit ips_path
    click_on 'Add IP address'
  end

  it 'displays an instruction to add the first location' do
    expect(page).to have_content('Add your first location')
  end

  context 'when adding the first location' do
    context 'with valid IP data' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'W1A 2AB'
        fill_in ip_input, with: '141.0.149.130'
      end

      it 'adds the location and IPs' do
        expect { click_on 'Add new location' }.to change(Location, :count).by(1)
      end

      it 'displays the success message to the user' do
        click_on 'Add new location'
        expect(page).to have_content('Successfully added 1 IP address to 30 Square')
      end

      it 'redirects to "After location created with IP" path for analytics' do
        click_on 'Add new location'
        expect(page).to have_current_path('/ips/created/location/with-ip')
      end
    end

    context 'with invalid IP data' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'W1A 2AB'
        fill_in ip_input, with: '10.wrong.0.1'
        fill_in second_ip_input, with: '10.0.0.3'
        click_on 'Add new location'
      end

      it 'asks me to re-enter IPs' do
        expect(page).to have_content('enter up to five IP addresses')
      end

      it 'tells me an IP is invalid' do
        expect(page).to have_content(
          "One or more IPs are incorrect"
        )
      end

      it 'does not add the invalid IP' do
        visit ips_path
        expect(page).not_to have_content('10.wrong.0.1')
      end
    end

    context 'when the IP field is left blank' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'W1A 2AB'
        click_on 'Add new location'
      end

      it 'adds the location' do
        expect(page).to have_content('30 Square')
      end

      it 'redirects to "After location created" path for analytics' do
        expect(page).to have_current_path('/ips/created/location')
      end
    end

    context 'when the location address is left blank' do
      before do
        fill_in 'Postcode', with: 'W1A 2AB'
        fill_in ip_input, with: '10.wrong.0.1'
        click_on 'Add new location'
      end

      it_behaves_like "errors in form"
    end

    context 'when the postcode is left blank' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: ''
        fill_in ip_input, with: '10.0.0.3'
        click_on 'Add new location'
      end

      it_behaves_like 'errors in form'
    end

    context 'when the postcode is not valid' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'WHATEVER'
        fill_in ip_input, with: '10.0.0.3'
        click_on 'Add new location'
      end

      it 'displays an error about the invalid postcode' do
        expect(page).to have_content('Postcode must be valid')
      end
    end
  end

  context 'when logged out' do
    before do
      sign_out
      visit new_location_path
    end

    it_behaves_like 'not signed in'
  end
end
