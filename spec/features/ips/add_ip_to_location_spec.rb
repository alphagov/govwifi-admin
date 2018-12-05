require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'

describe 'Add an IP to a location' do
  let(:user) { create(:user) }
  let(:location) { create(:location, address: '10 Street', postcode: 'XX YYY', organisation: user.organisation) }
  let!(:ip) { create(:ip, location: location) }

  let(:first_location) { 'location_ips_attributes_0_address' }

  context 'with permissions' do
    before do
      sign_in_user user
      visit ips_path
      click_on 'Add IP to this location'
    end

    it 'asks me to enter an IP' do
      expect(page).to have_content('Enter IP address (IPv4 only)')
    end

    context 'with valid data' do
      before do
        fill_in first_location, with: '10.0.0.1'
      end

      it 'adds the IP' do
        expect {
          click_on 'Add new IP address'
        }.to change { Ip.count }.by(1)

        expect(page).to have_content('IP added to 10 Street, XX YYY')
        expect(Ip.last.location).to eq(location)
      end
    end

    context 'with invalid data' do
      before do
        fill_in first_location, with: '10.wrong.0.1'
        click_on 'Add new IP address'
      end

      it_behaves_like 'errors in form'

      it 'renders the add ip to location form' do
        within("h2#title") do
          expect(page).to have_content("Add an IP address to #{location.address}")
        end
      end

      it 'tells me what I entered was invalid' do
        expect(page).to have_content(
          'Address must be a valid IPv4 address (without subnet)'
        )
      end
    end
  end

  context 'without permissions' do
    before do
      user.permission.update(can_manage_locations: false)
      sign_in_user user
      visit ips_path
    end

    it 'does not show the add IP link' do
      expect(page).to_not have_link('+ add IP')
    end
  end
end
