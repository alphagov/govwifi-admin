describe "View and search locations", type: :feature do
  let(:user) { create(:user, :super_admin) }
  let(:organisation) { create(:organisation) }

  before do
    create(:location, address: "69 Garry Street, London", postcode: "HA7 2BL", organisation:)
    sign_in_user user
    visit root_path
    within(".leftnav") { click_on "All Locations" }
  end

  it "takes the user to the locations page" do
    expect(page).to have_content("GovWifi locations")
  end

  context "with all the locations details" do
    it "lists the full address of the location" do
      expect(page).to have_content("69 Garry Street, London, HA7 2BL")
    end

    it "lists the organisation the location belongs to" do
      expect(page).to have_content(organisation.name)
    end

    it "does not show the pager because there is only one page" do
      expect(page).to_not have_css(".pager__controls")
    end
  end

  context "select an organisation with 41 locations" do
    before :each do
      FactoryBot.create_list(:location, 40, organisation:)
      click_on organisation.name
    end
    it "shows 5 pages, a 'Next' link but not a 'Prev' link" do
      expect(page).to_not have_content "Prev"
      expect(page).to have_content(/1\s*2\s*3\s*4\s*5\s*Next/).twice
    end
    it "shows 5 pages, a 'Next' link and a 'Prev' link" do
      within(".pager__controls", match: :first) { click_on "3" }
      expect(page).to have_content(/Prev\s*1\s*2\s*3\s*4\s*5\s*Next/).twice
    end
    it "shows 5 pages, a 'Prev' link but not a 'Next' link" do
      within(".pager__controls", match: :first) { click_on "5" }
      expect(page).to_not have_content "Next"
      expect(page).to have_content(/Prev\s*1\s*2\s*3\s*4\s*5/).twice
    end
  end

  context "selecting a location" do
    it "takes the user to the organisation page" do
      click_on "69 Garry Street, London, HA7 2BL"
      expect(page).to have_content(organisation.name)
    end
  end
end
