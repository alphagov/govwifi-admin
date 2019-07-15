describe 'View and search locations', type: :feature do
  let(:user) { create(:user, :super_admin) }
  let(:organisation) { create(:organisation) }

  before do
    create(:location, address: '69 Garry Street, London', postcode: 'HA7 2BL', organisation: organisation)
    sign_in_user user
    visit root_path
    within('.leftnav') { click_on 'Locations' }
  end

  it 'takes the user to the locations page' do
    expect(page).to have_content("GovWifi locations")
  end

  context 'with all the locations details' do
    it 'lists the full address of the location' do
      expect(page).to have_content("69 Garry Street, London, HA7 2BL")
    end

    it 'lists the organisation the location belongs to' do
      expect(page).to have_content(organisation.name)
    end
  end
end
