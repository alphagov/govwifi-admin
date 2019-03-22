describe 'Downloading the GovWifi poster', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
    visit root_path
  end

  it 'displays the download poster link' do
    expect(page).to have_link('Download a poster to advertise GovWifi is available in your building(s)')
  end

  it 'allows the user to click on link and download the poster' do
    click_on 'Download a poster to advertise GovWifi is available in your building(s)'
    expect(page.response_headers['Content-Type']).to eq('image/png')
  end
end
