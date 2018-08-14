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
    let(:user) { create(:user) }

    context 'when user has no IPs' do
      before do
        sign_in_user user
        visit ips_path
      end

      it 'shows there are no IPs' do
        expect(page).to have_content "Add IP"
        expect(page).to have_content "You have not added any IPs"
      end
    end

    context 'when user has IPs' do
      let!(:ip_1) { create(:ip, user: user) }
      let!(:ip_2) { create(:ip, user: user) }

      before do
        sign_in_user user
        visit ips_path
      end

      it 'displays the radius secret key' do
        expect(page).to have_content("Your Secret Key")
        expect(page).to have_content(user.radius_secret_key)
      end

      it 'displays the list of IPs' do
        expect(page).to have_content(ip_1.address)
        expect(page).to have_content(ip_2.address)
      end
    end
  end
end
