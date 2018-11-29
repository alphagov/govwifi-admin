require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'

describe 'Add an IP to my account' do
  context 'and the new location is invalid' do
    let!(:user) { create(:user) }
    let(:location) { create(:location, address: '10 Street', postcode: 'XX YYY', organisation: user.organisation) }
    let!(:ip) { create(:ip, location: location) }

    before do
      sign_in_user user
      visit ips_path
      click_on 'add IP to this location'
    end

    context 'when logged in' do
      it 'asks me to enter an IP' do
        expect(page).to have_content('Enter IP address (IPv4 only)')
      end

      context 'with valid data' do
        before do
          fill_in 'address', with: '10.0.0.1'
        end

        it 'adds the IP' do
          expect {
            click_on 'Add new IP address'
          }.to change { Ip.count }.by(1)

          expect(page).to have_content('10.0.0.1 added')
          expect(Ip.last.location).to eq(location)
        end
      end

      context 'with invalid data' do
        before do
          fill_in 'address', with: '10.wrong.0.1'
          click_on 'Add new IP address'
        end

        it_behaves_like 'errors in form'

        it 'asks me to re-enter my IP' do
          expect(page).to have_content('Enter IP address')
        end

        it 'tells me what I entered was invalid' do
          expect(page).to have_content(
            'Address must be a valid IPv4 address (without subnet)'
          )
        end
      end
    end
  end
end
