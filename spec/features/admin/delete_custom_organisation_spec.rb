describe 'deleting a custom organisation name' do
  let!(:custom_org_name1) { create(:custom_organisation_name, name: 'DummyOrg1') }
  let!(:custom_org_name2) { create(:custom_organisation_name, name: 'DummyOrg2') }
  let!(:custom_org_name3) { create(:custom_organisation_name, name: 'DummyOrg3') }

  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the custom organisations page' do
    before do
      sign_in_user admin_user
      visit admin_custom_organisations_path
    end

    it 'allows the user to delete a custom organisation' do
      click_link "custom-organisation-#{custom_org_name1.id}"
      click_on 'Yes, remove this organisation'
      visit admin_custom_organisations_path
      expect(page).to_not have_content("DummyOrg1")
    end
  end

  context 'changes the number of custom orgs in the register' do
    before do
      sign_in_user admin_user
      visit admin_custom_organisations_path
    end

    it 'will remove the custom org from the register' do
      click_link "custom-organisation-#{custom_org_name3.id}"

      expect {
        click_on 'Yes, remove this organisation'
      }.to change { CustomOrganisationName.count }.by(-1)
    end
  end
end
