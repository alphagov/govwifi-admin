describe 'Whitelisting an organisation', type: :feature do
  before do
    sign_in_user create(:user, :super_admin)
    visit new_admin_whitelist_path
  end

  it 'displays the new page' do
    expect(page).to have_content('Whitelist an organisation')
  end
end
