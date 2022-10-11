describe "Change password", type: :feature do
  let(:user) { create(:user, :with_organisation) }

  before do
    sign_in_user user
    visit settings_path
  end

  context "when changing a password" do
    it "displays the change password link on the settings page" do
      expect(page).to have_content("Change your password")
    end

    it "takes you to the form to change your password" do
      click_on "Change your password"
      expect(page).to have_content("Change your password")
    end
  end
end
