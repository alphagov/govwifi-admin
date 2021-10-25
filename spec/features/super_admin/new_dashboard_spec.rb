describe "Signing in as a (new) super admin", type: :feature do
  let(:user) { create(:user, :new_admin) }

  context "when visiting the home page" do
    before do
      sign_in_user user
      visit super_admin_neo_dashboard_path
    end

    it "shows the new dashboard" do
      expect(page).to have_content("This is our new dashboard")
    end

    it "renders the new sidebar" do
      expect(page).to have_content("New features!")
    end

    it "does not render an alpha warning" do
      expect(page).to_not have_content("alpha")
    end

    it "renders a link to give feedback" do
      expect(page).to have_content("your feedback will help us to improve it")
    end
  end
end
