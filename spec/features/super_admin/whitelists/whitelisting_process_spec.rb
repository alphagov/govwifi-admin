describe 'Whitelisting an organisation', type: :feature do
  before do
    sign_in_user create(:user, :super_admin)
    visit new_admin_whitelist_path
  end

  it 'displays the new page' do
    expect(page).to have_content('Give an organisation access to GovWifi')
    expect(page).to have_link('Start here')
    expect(page).to have_link('Organisations whitelist')
    expect(page).to have_link('Users whitelist')
  end
end
