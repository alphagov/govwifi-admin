require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'View all my IP addresses' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'when logged out' do
    before do
      visit ips_path
    end

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    context 'when user has no IPs' do
      before do
        sign_in_user user
        visit ips_path
      end

      it 'shows there are no IPs' do
        expect(page).to have_content 'Add IP'
        expect(page).to have_content 'You need to add the IPs of your authenticator(s)'
      end
    end

    context 'when user has IPs' do
      let(:location) { user.organisation.locations.first }
      let!(:ip_1) { create(:ip, location: location) }
      let!(:ip_2) { create(:ip, location: location) }

      before do
        sign_in_user user
        visit ips_path
      end

      it 'displays the list of my allowed IPs' do
        expect(page).to have_content(ip_1.address)
        expect(page).to have_content(ip_2.address)
      end

      context 'Viewing someone elses IP Addresses' do
        let(:location) { create(:organisation).locations.first }
        let(:other_ip) { create(:ip, location: location) }

        it 'Redirects to the root path' do
          visit ip_path(other_ip)
          expect(page.current_path).to eq(root_path)
        end
      end
    end
  end
end
