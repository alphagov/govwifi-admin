require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'View IP addresses' do
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

    context 'with no IPs' do
      before do
        sign_in_user user
        visit ips_path
      end

      it 'shows no IPs' do
        expect(page).to have_content 'Add IP'
        expect(page).to have_content 'You need to add the IPs of your authenticator(s)'
      end
    end

    context 'with IPs' do
      let(:ip_one) { '10.0.0.1' }
      let(:ip_two) { '10.0.0.2' }
      let(:address_one) { '179 Southern Street, Southwark' }
      let(:address_two) { '123 Northern Street, Whitechapel' }
      let(:postcode_one) { 'SE4 4BK' }
      let(:postcode_two) { 'NE7 3UP' }

      before do
        location_one = create(:location,
          organisation: user.organisation,
          address: address_one,
          postcode: postcode_one)

        location_two = create(:location,
          organisation: user.organisation,
          address: address_two,
          postcode: postcode_two)

        create(:ip, address: ip_one, location: location_one)
        create(:ip, address: ip_two, location: location_two)

        sign_in_user user
        visit ips_path
      end

      it 'shows those IPs' do
        expect(page).to have_content(ip_one)
        expect(page).to have_content(ip_two)
      end

      it 'shows the related addresses' do
        expect(page).to have_content(address_one)
        expect(page).to have_content(address_two)
      end

      it 'shows the related postcodes' do
        expect(page).to have_content(postcode_one)
        expect(page).to have_content(postcode_two)
      end
    end
  end
end
