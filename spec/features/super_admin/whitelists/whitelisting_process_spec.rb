describe 'Whitelisting an organisation', type: :feature do
  before do
    sign_in_user create(:user, :super_admin)
    visit new_admin_whitelist_path
  end

  it 'displays the start page' do
    expect(page).to have_content('Give an organisation access to GovWifi')
  end

  it 'allows the user to see the list of whitelisted organisations' do
    click_on "Organisations whitelist"
    expect(page).to have_content("Custom Organisations that are already in our register")
  end

  it 'allows the user to see the list of whitelisted email domains' do
    click_on "Users whitelist"
    expect(page).to have_content("Email domains that are already whitelisted")
  end
end
