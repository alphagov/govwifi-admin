# TODO: don't require eveerything ever to fill in a form
require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'
require 'features/support/activation_notice'
require 'support/notifications_service'
require 'support/confirmation_use_case'
require 'timecop'

describe 'even more requires' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  after { Timecop.return }

  describe 'Viewing IPs' do
    context 'when one has been added' do
      let(:user) do
        user = create(:user, :with_organisation)
        create(:location, organisation: user.organisation)
        user
      end

      before do
        sign_in_user user
        visit new_ip_path
        fill_in 'address', with: '10.0.0.1'
        fill_in 'Enter new location address', with: 'home'
        fill_in 'Enter new location postcode', with: 'XYZ'
        click_on 'Add new IP Address'
      end

      context 'and I view it immediately' do
        it 'shows it is activating tomorrow' do
          expect(page).to have_content('Activating tomorrow')
        end
      end

      context 'and I view it after a day has passed' do
        before do
          Timecop.freeze(Date.today + 1)
          visit ips_path
        end

        it 'shows it as available' do
          expect(page).to have_content('Available')
          expect(page).to_not have_content('tomorrow')
        end
      end
    end
  end
end
