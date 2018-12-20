describe 'Allowing a user to download the GovWifi poster' do
  let(:user) { create(:user) }

  context 'shows the download poster link on the home page' do
    before do
      sign_in_user user
      visit root_path
    end

    it 'allows the user to click on link and download the poster' do
      expect(page).to have_content("Download a poster to advertise GovWifi is available in your building(s)")
    end
  end
end
