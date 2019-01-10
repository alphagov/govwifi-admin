describe 'viewing the activity of GovWifi in an organisation',focus: true do
  context 'within the last 24 hours' do
    let(:ip) { '1.2.3.4' }
    let(:username_1) { 'AAAAAA' }
    let(:username_2) { 'BBBBBB' }
    let(:username_3) { 'CCCCCC' }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      Session.create!(
        start: 3.hours.ago,
        username: username_1,
        mac: "",
        ap: "",
        siteIP: ip,
        success: true,
        building_identifier: ""
      )

      Session.create!(
        start: 10.hours.ago,
        username: username_2,
        mac: "",
        ap: "",
        siteIP: ip,
        success: true,
        building_identifier: ""
      )

      Session.create!(
        start: 2.days.ago,
        username: username_3,
        mac: "",
        ap: "",
        siteIP: ip,
        success: false,
        building_identifier: ""
      )

      create(:ip, location_id: location.id, address: ip)

      sign_in_user admin_user
      visit root_path

    end

      it 'displays the number of successful connections' do
        within('div#user-statistics') do
          expect(page).to have_content("There have been 2 connections")
        end
      end
  end
end
