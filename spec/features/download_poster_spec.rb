describe 'Downloading the GovWifi poster', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
    visit root_path
  end

  it 'allows the user to click on link and download the poster' do
    expect(page).to have_content("Download a poster to advertise GovWifi is available in your building(s)")
  end
end
