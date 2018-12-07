require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'
require 'features/support/activation_notice'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Add IP to existing location (from add ip)' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  let!(:user) { create(:user) }
  let!(:location_1) { create(:location, address: '10 Street', postcode: 'XX YYY', organisation: user.organisation) }
  let!(:location_2) { create(:location, address: '50 Road', postcode: 'ZZ AAA', organisation: user.organisation) }

  context 'when logged in' do
    before do
      sign_in_user user
      visit ips_path
      click_on 'Add IP address'
    end

    it_behaves_like 'shows activation notice'

    it 'asks me to enter an IP' do
      expect(page).to have_content('Enter IP address (IPv4 only)')
    end

    context 'and that IP is valid' do
      before do
        fill_in 'address', with: '10.0.0.1'
        select '10 Street, XX YYY'
        click_on 'Add new IP address'
      end

      it 'shows me the IP was added' do
        expect(page).to have_content('10.0.0.1 added')
      end

      it 'adds IP to a selected location' do
        expect(Ip.last.location).to eq(location_1)
      end

      context 'when I add a second IP to a different location' do
        before do
          visit new_ip_path
          fill_in 'address', with: '10.0.0.2'
          select '50 Road, ZZ AAA'
          click_on 'Add new IP address'
        end

        it 'shows both new IPs' do
          expect(page).to have_content('10.0.0.1')
          expect(page).to have_content('10.0.0.2')
        end

        it 'adds IP to a selected location' do
          expect(Ip.last.location).to eq(location_2)
        end
      end
    end

    context 'and that IP is invalid' do
      before do
        fill_in 'address', with: '10.wrong.0.1'
        select '10 Street, XX YYY'
        click_on 'Add new IP address'
      end

      it_behaves_like "errors in form"

      it 'asks me to re-enter my IP' do
        expect(page).to have_content('Enter IP address')
      end

      it 'tells me what I entered was invalid' do
        expect(page).to have_content(
          "Address '10.wrong.0.1' is not valid"
        )
      end

      context 'when looking back at the list' do
        before { visit ips_path }

        it 'has not added the invalid IP' do
          expect(page).to_not have_content('10.wrong.0.1')
        end
      end
    end

    context 'and that IP is a duplicate' do
      before do
        create(:ip, address: "1.1.1.1")
        fill_in 'address', with: '1.1.1.1'
        select '10 Street, XX YYY'
        click_on 'Add new IP address'
      end

      it_behaves_like 'errors in form'

      it 'tells me what I entered was invalid' do
        expect(page).to have_content('Address has already been taken')
      end
    end
  end
end
