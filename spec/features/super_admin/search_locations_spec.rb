describe 'View and search locations', type: :feature, focus: true do
  before do
    user = create(:user, :super_admin)
    sign_in_user user
    visit root_path
    click_on 'Locations'
  end

  it 'takes the user to the locations page' do
    expect(page).to have_content("GovWifi locations")
  end
end
