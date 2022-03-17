describe "Lookup wifi user contact details", type: :feature do
  let(:user) { create(:user, :super_admin) }
  let(:search_term) { "" }
  let(:contact) { "wifi.user@govwifi.org" }

  before do
    create(:wifi_user, username: "zZyYxX", contact:)

    sign_in_user user

    visit root_path

    visit new_logs_search_path

    choose "Email address"
    click_on "Go to search"

    fill_in "search_term", with: search_term
    click_on "Find user details"
  end

  context "with no search term" do
    it "presents an error message" do
      expect(page).to have_content("Search term can't be blank")
    end
  end

  context "with a username search term" do
    let(:search_term) { "ZZYYXX" }

    it "presents the end user contact details" do
      expect(page).to have_content("wifi.user@govwifi.org")
    end

    it "provides a link to search logs by username" do
      expect(page).to have_link("zZyYxX", href: logs_path(username: "zZyYxX"))
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
