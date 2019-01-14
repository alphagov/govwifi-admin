describe 'viewing the activity of GovWifi in an organisation', focus: true do
  context 'within the last 24 hours' do
    let(:ip) { '1.2.3.4' }
    let(:username_1) { 'AAAAAA' }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      create(:ip, location_id: location.id, address: ip)
      Session.create(start: 3.hours.ago, success: true, username: username_1, siteIP: ip)
      Session.create(start: 10.hours.ago, success: false, username: username_1, siteIP: ip)

      sign_in_user admin_user
      visit root_path
    end

    xit 'displays the number of successful connections' do
      within('div#user-statistics') do
        expect(page).to have_content("There have been 1 connections")
      end
    end

    it 'displays a message if there are no successful connections' do
      within('div#user-statistics') do
        expect(page).to have_content("There have been no connections")
      end
    end
  end
end
