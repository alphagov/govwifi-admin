require 'features/support/sign_up_helpers'

describe 'View authentication requests for an IP' do
  context 'with results' do
    let(:ip) { '127.0.0.1' }
    let(:username) { 'ABCDEF' }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, :confirmed, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      Session.create!(
        start: 3.days.ago,
        username: username,
        siteIP: '127.0.0.1',
        success: true
      )

      create(:ip, location_id: location.id, address: ip)

      sign_in_user admin_user
      visit ips_path

      within('#ips-table') do
        click_on 'View logs'
      end
    end

    context 'searching by IP address' do
      it 'displays the authentication requests' do
        expect(page).to have_content("Displaying logs for #{ip}")
        expect(page).to have_content(username)
      end
    end
  end
end
