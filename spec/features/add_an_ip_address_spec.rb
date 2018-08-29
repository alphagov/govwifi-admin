require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'
require 'features/support/activation_notice'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Add an IP to my account' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'when logged in' do
    before do
      sign_in_user create(:user)
      visit ips_path
      click_on "Add IP Address"
    end

    it_behaves_like 'shows activation notice'

    it 'asks me to enter an IP' do
      expect(page).to have_content('Enter IP Address (IPv4 only)')
    end

    context 'and that IP is valid' do
      before do
        fill_in 'address', with: '10.0.0.1'
        click_on 'Save'
      end

      it 'shows a success message' do
        expect(page).to have_content('IP Added')
      end

      it 'shows me the new IP' do
        expect(page).to have_content('10.0.0.1')
      end

      context 'when I add a second IP' do
        before do
          visit new_ip_path
          fill_in 'address', with: '10.0.0.2'
          click_on 'Save'
        end

        it 'shows both new IPs' do
          expect(page).to have_content('10.0.0.1')
          expect(page).to have_content('10.0.0.2')
        end
      end
    end

    context 'and that IP is invalid' do
      before do
        fill_in 'address', with: '10.wrong.0.1'
        click_on 'Save'
      end

      it_behaves_like 'errors in form'

      it 'asks me to re-enter my IP' do
        expect(page).to have_content('Enter IP Address')
      end

      it 'tells me what I entered was invalid' do
        expect(page).to have_content(
          'Address must be a valid IPv4 address (without subnet)'
        )
      end

      context 'when looking back at the list' do
        before { visit ips_path }

        it 'has not added the invalid IP' do
          expect(page).to_not have_content('10.wrong.0.1')
        end
      end
    end
  end

  context 'when logged out' do
    before { visit new_ip_path }

    it_behaves_like 'not signed in'
  end
end
