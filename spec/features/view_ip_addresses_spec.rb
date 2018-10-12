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
    let(:user) { create(:user, :confirmed, :with_organisation) }

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
      let(:ip_1) { '10.0.0.1' }
      let(:ip_2) { '10.0.0.2' }
      let(:address_1) { '179 Southern Street, Southwark' }
      let(:address_2) { '123 Northern Street, Whitechapel' }
      let(:postcode_1) { 'SE4 4BK'}
      let(:postcode_2) { 'NE7 3UP'}

      before do
        location_1 = create(:location,
          organisation: user.organisation ,
          address: address_1,
          postcode: postcode_1
        )

        location_2 = create(:location,
          organisation: user.organisation ,
          address: address_2,
          postcode: postcode_1
        )

        create(:ip, address: ip_1, location: location_1)
        create(:ip, address: ip_2, location: location_2)

        sign_in_user user
        visit ips_path
      end

      it 'shows those IPs' do
        expect(page).to have_content(ip_1)
        expect(page).to have_content(ip_2)
      end

      it 'shows the related addresses' do
        expect(page).to have_content(address_1)
        expect(page).to have_content(address_2)
      end

      it 'shows the related postcoes' do
        expect(page).to have_content(postcode_1)
        expect(page).to have_content(postcode_2)
      end
    end
  end
end
