describe "Change password", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in_user user
  end

  it_behaves_like "shows the settings page"

  context "when changing a password" do
    it "displays the change password link on the settings page" do
      visit settings_path
      expect(page).to have_content("Change your password")
    end

    it "takes you to the form to change your password" do
      click_on "Change your password"
      expect(page).to have_content("Change your password")
    end

    it "displays accordion with text 'help with choosing a strong password'" do
      expect(page).to have_content("Help with choosing a strong password")
    end

    it "displays clear instructions on help with choosing a strong password" do
      click_on "Help with choosing a strong password"
      expect(page).to have_content("Use 3 random words next to each other with a number and special character at the end, for example: ThreeRandomWords3!")
    end
  end
end
