describe "Lookup wifi user contact details", type: :feature do
  let(:user) { create(:user, :super_admin) }
  let(:search_term) { "" }
  let(:contact) { "wifi.user@govwifi.org" }

  before do
    create(:wifi_user, username: "zZyYxX", contact:)

    sign_in_user user
    visit root_path
    click_on "User Details"

    fill_in "Username, email address or phone number", with: search_term
    click_on "Find user details"
  end

  context "with no search term" do
    it "presents an error message" do
      expect(page).to have_content("Search term can't be blank").twice
    end
  end

  context "with a username search term" do
    let(:search_term) { "ZZYYXX" }

    it "presents the end user contact details" do
      expect(page).to have_content("wifi.user@govwifi.org")
    end

    describe "click on the username link" do
      it "shows a page with logs for the user" do
        click_on "zZyYxX"
        expect(page).to have_content("The username \"zZyYxX\" is not reaching the GovWifi service")
      end
    end
  end

  context "with an unknown username" do
    let(:search_term) { "AAAAAA" }

    it "presents the end user contact details" do
      expect(page).to have_content("Nothing found for 'AAAAAA'")
    end
  end

  context "with a phone number search term" do
    let(:search_term) { "+44 7891 234567" }
    let(:contact) { "+447891234567" }

    it "presents the end user username" do
      expect(page).to have_content("zZyYxX")
    end
  end

  context "with an email address search term" do
    let(:search_term) { "wifi.user@govwifi.org" }

    it "presents the end user username" do
      expect(page).to have_content("zZyYxX")
    end
  end
end
