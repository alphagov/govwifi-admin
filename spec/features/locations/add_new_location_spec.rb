require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'
require 'features/support/activation_notice'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Add new location' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  let(:user) { create(:user) }
  let(:ip_input) { "location_ips_attributes_0_address" }
  let(:second_ip_input) { "location_ips_attributes_1_address" }

  context 'when logged in' do
    before do
      sign_in_user user
      visit ips_path
      click_on 'Add IP address'
      click_on 'Add a new location'
    end

    context 'and that IP is valid' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'CC DDD'
        fill_in ip_input, with: '10.0.0.1'
        click_on 'Add new location'
      end

      it 'shows me the location was added' do
        expect(page).to have_content('30 Square, CC DDD added')
      end

      it 'adds the location and IPs' do
        expect(Ip.last.location.address).to eq('30 Square')
        expect(Ip.last.location.postcode).to eq('CC DDD')
      end
    end

    context 'and that IP is invalid' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'CC DDD'
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

      context 'when looking back at the list' do
        before { visit ips_path }

        it 'has not added the invalid IP' do
          expect(page).to_not have_content('10.wrong.0.1')
        end
      end
    end

    context 'and that IP is blank' do
      before do
        fill_in 'Address', with: '30 Square'
        fill_in 'Postcode', with: 'CC DDD'
        click_on 'Add new location'
      end

      context 'when looking back at the list' do
        before { visit ips_path }

        it 'has added the location' do
          expect(page).to have_content('30 Square')
        end
      end
    end

    context 'and the address is blank' do
      before do
        fill_in 'Postcode', with: 'CC DDD'
        fill_in ip_input, with: '10.wrong.0.1'
        click_on 'Add new location'
      end

      it_behaves_like "errors in form"
    end
  end

  context 'when logged out' do
    before { visit new_location_path }

    it_behaves_like 'not signed in'
  end
end
