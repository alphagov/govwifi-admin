describe 'viewing the activity of GovWifi in an organisation' do
  context 'within the last 24 hours' do
    let(:ip) { '1.2.3.4' }
    let(:username_1) { 'AAAAAA' }
    let(:username_2) { 'BBBBBB' }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      create(:ip, location_id: location.id, address: ip)
      sign_in_user admin_user
      visit root_path
    end

    it 'displays a message if there are no successful connections' do
      within('div#user-statistics') do
        expect(page).to have_content("There have been no connections")
      end
    end

    xit 'displays the number of successful connections' do
      Session.create(start: 3.hours.ago, success: true, username: username_1, siteIP: ip)
      Session.create(start: 5.hours.ago, success: true, username: username_2, siteIP: ip)
      Session.create(start: 10.hours.ago, success: false, username: username_1, siteIP: ip)

      within('div#user-statistics') do
        expect(page).to have_content("There have been 2 connections")
      end
    end
  end
end
