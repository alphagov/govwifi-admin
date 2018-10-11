require 'features/support/sign_up_helpers'
require 'timecop'

describe 'with a stubbed notifications service' do
  include_examples 'notifications service'

  after { Timecop.return }

  describe 'Viewing IPs' do
    context 'when one has been added' do
      let(:user) { create(:user, :with_organisation) }

      before do
        sign_in_user user
        visit new_ip_path
        fill_in 'address', with: '10.0.0.1'
        click_on 'Add new IP address'
      end

      context 'and I view it immediately' do
        before { visit ips_path }

        it 'shows it is activating tomorrow' do
          expect(page).to have_content('Not available until 6am tomorrow')
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
