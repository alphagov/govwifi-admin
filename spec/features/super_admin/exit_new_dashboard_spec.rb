describe "Exiting new dashboard", type: :feature do
  let(:classic) { create(:user, :super_admin) }
  let(:neo) { create(:user, :new_admin) }

  describe "when viewed as a classic super admin" do
    before do
      sign_in_user classic
      visit super_admin_neo_dashboard_path
    end

    context "when the previous logged-in organisation was superadmin" do
      it "goes the old super-admin interface" do
        page.click_on "Manage organisations"

        expect(page).to have_current_path super_admin_organisations_path
      end
    end

    context "when the logged-in previous organisation was a regular one" do
      before do
        org = create(:organisation, name: "Gov Org 2")
        classic.organisations << org

        visit change_organisation_path
        page.click_on "Gov Org 2"

        visit super_admin_neo_dashboard_path
      end

      it "points to the organisation panel" do
        click_on "Manage organisations"

        expect(page).to have_current_path ips_path
      end
    end
  end

  describe "when viewing as a new super admin" do
    before do
      sign_in_user neo
      visit super_admin_neo_dashboard_path
    end

    it "goes to the overview path" do
      page.click_on "Manage organisations"

      expect(page).to have_current_path signed_in_new_help_path
    end
  end
end
