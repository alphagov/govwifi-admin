describe 'viewing the activity of GovWifi in an organisation' do
  let(:username_1) { 'AAAAAA' }
  let(:username_2) { 'BBBBBB' }
  let(:ip) { '1.2.3.4' }
  let(:admin_user) { create(:user, organisation: organisation) }
  let(:organisation) { create(:organisation, :with_locations) }
  let(:location) { organisation.locations.first }

  context 'within the past 24 hours' do
    context 'with no successful connections' do
      before do
        Session.create!(start: 3.hours.ago, success: false, username: username_1, siteIP: ip)
        Session.create!(start: 5.hours.ago, success: false, username: username_1, siteIP: ip)

        create(:ip, location: location, address: ip)

        sign_in_user admin_user
        visit root_path
      end

      it 'displays a message if there are no successful connections' do
        within('div#user-statistics') do
          expect(page).to have_content("No connections")
        end
      end
    end

    context 'with at least one successful connection' do
      before do
        Session.create!(start: 3.hours.ago, success: false, username: username_1, siteIP: ip)
        Session.create!(start: 5.hours.ago, success: true, username: username_2, siteIP: ip)

        create(:ip, location: location, address: ip)

        sign_in_user admin_user
        visit root_path
      end

      it 'displays the number of successful connections' do
        within('div#user-statistics') do
          expect(page).to have_content("1 connection")
        end
      end
    end
  end
end
