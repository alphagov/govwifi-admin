describe "Delete a custom organisation name", type: :feature do
  let(:admin_user) { create(:user, :super_admin) }

  before do
    create(:custom_organisation_name, name: "DummyOrg1")
    create(:custom_organisation_name, name: "DummyOrg2")
    sign_in_user admin_user
    visit super_admin_allowlist_organisation_names_path
  end

  context "when deleting a custom organisation name" do
    let(:allowed_organisation_1) { CustomOrganisationName.find_by(name: "DummyOrg1") }

    before do
      click_link "custom-organisation-#{allowed_organisation_1.id}"
    end

    it "removes the correct organisation name from the list" do
      click_on "Yes, remove this organisation"
      within ".govuk-table" do
        expect(page).not_to have_content(allowed_organisation_1.name)
      end
    end

    it "removes the organisation name from the register" do
      expect {
        click_on "Yes, remove this organisation"
      }.to change(CustomOrganisationName, :count).by(-1)
    end
  end
end
