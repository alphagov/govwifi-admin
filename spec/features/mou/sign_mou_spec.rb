describe "Sign MOU", type: :feature do
  let(:organisation) { create(:organisation, latest_mou_version: 2.0, mou_version_change_date: Time.zone.today) }
  let(:user) { create(:user, organisations: [organisation]) }

  before do
    sign_in_user user
    visit settings_path
  end

  it "displays link to sign MOU" do
    expect(page).to have_link("Sign MOU")
  end

  context "when a user clicks on Sign MOU button" do
    before { click_on "Sign MOU" }

    it "displays the initial tag on the URL" do
      expect(page).to have_current_path("/mou/new")
    end

    it "has a link to the MOU" do
      expect(page).to have_link("GovWifi’s MOU (opens in another tab)")
    end

    it "displays a checkbox that is not initially checked" do
      expect(page).to have_field("accept_terms", checked: false)
    end

    context "when signing the MOU" do
      before do
        check "accept_terms"
        click_button "Accept the MOU"
      end

      it "creates an MOU when the user ticks the checkbox and accepts terms" do
        expect(page).to have_content("Your organisation has accepted the memorandum of understanding")
      end

      it "displays a button to review the MOU on the settings page after MOU creation" do
        expect(page).to have_link("Review")
      end

      it "displays a notification after MOU creation" do
        expect(page).to have_content("Your organisation has accepted the memorandum of understanding")
      end
    end
  end
end
