describe 'View and search locations', type: :feature, focus: true do
  let(:user) { create(:user, :super_admin) }
  let(:organisation) { create(:organisation) }
  let!(:location_1) { create(:location, address: '69 Garry Street, London', postcode: 'HA7 2BL', organisation: organisation) }

  before do
    sign_in_user user
    visit root_path
    click_on 'Locations'
  end

  it 'takes the user to the locations page' do
    expect(page).to have_content("GovWifi locations")
  end

  context 'view all the locations details' do
    it 'lists the full address of the location' do
      expect(page).to have_content("69 Garry Street, London, HA7 2BL")
    end
  end
end
