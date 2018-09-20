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
      let(:ip_1) { '10.0.0.1' }
      let(:ip_2) { '10.0.0.2' }
      let(:address_1) { '179 Southern Street, Southwark' }
      let(:address_2) { '123 Northern Street, Whitechapel' }

      let(:org) { user.organisation }
      let(:location_1) { org.locations.create!(address: address_1) }
      let(:location_2) { org.locations.create!(address: address_2) }

      before do
        create(:ip, address: ip_1, location: location_1)
        create(:ip, address: ip_2, location: location_2)

        sign_in_user user
        visit ips_path
      end

      it 'displays the list of my allowed IPs' do
        expect(page).to have_content(ip_1.address)
        expect(page).to have_content(ip_2.address)
      end

      context 'Viewing someone elses IP Addresses' do
        let(:other_organisation) { create(:organisation) }
        let(:location) { create(:location, organisation: other_organisation) }
        let(:other_ip) { create(:ip, location: location) }
        expect(page).to have_content(address_1)
        expect(page).to have_content(address_2)

        expect(page).to have_content(ip_1)
        expect(page).to have_content(ip_2)
      end
    end
  end
end
