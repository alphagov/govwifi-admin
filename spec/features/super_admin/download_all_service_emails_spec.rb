describe 'Downloading all the service emails', type: :feature, focus: true do
  let(:user) { create(:user, :super_admin) }

  before do
    sign_in_user user
    visit admin_organisations_path
  end

  it 'will have the link to download all service emails' do
    expect(page).to have_content('Download all service emails')
  end
end
