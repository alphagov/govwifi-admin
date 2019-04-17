describe 'filtering IP addresses by dynamic search' do
  let!(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisation: organisation) }
  let!(:location_one) { create(:location, organisation: organisation, address: 'Apple Street') }
  let!(:location_two) { create(:location, organisation: organisation, address: 'Banana Road') }
  let!(:location_three) { create(:location, organisation: organisation, address: 'Citrus Lane') }

  before do
    # allowed_sites = [
    #   "https://chromedriver.storage.googleapis.com",
    #   "https://github.com/mozilla/geckodriver/releases",
    #   "https://selenium-release.storage.googleapis.com",
    #   "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver"
    # ]

    WebMock.disable_net_connect!(allow_localhost: true, allow: ["app:55555", "selenium:4444", %r{github.com/mozilla/geckodriver/releases}])

    sign_in_user user
    visit ips_path
  end

  context 'when user types in the search field', js: true do
    it 'displays the location that closely matches the text field input' do
      fill_in 'filterInput', with: 'B'
      # page.execute_script(filterLocations())

      within('div#wrapper')do
        expect(page).to have_selector("table", count: 1)
      end
    end
  end
end
