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
      let(:user) { create(:user, :with_organisation) }
      let(:ip_field) { 'Enter IP Address (IPv4 only)' }

      before do
        sign_in_user user
        visit new_ip_path
        fill_in ip_field, with: '10.0.0.1'
        click_on 'Add IP'
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
