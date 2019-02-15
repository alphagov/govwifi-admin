require 'support/confirmation_use_case'

describe 'deleting a custom organisation name' do
  include_examples 'confirmation use case spy'

  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the custom organisations page' do
    before do
      sign_in_user admin_user
      visit admin_custom_organisations_path
      CustomOrganisationName.create(name: 'DummyOrg1')
      CustomOrganisationName.create(name: 'DummyOrg2')
    end

    it 'allows the user to delete a custom organisation' do
      within("tr#data-id-1") do
        click_link 'Remove'
      end

      click_on 'Yes, remove this organisation'
      click_on 'Allow organisation'
      expect(page).to_not have_content("DummyOrg1")
    end
  end

  context 'changes the number of custom orgs in the register' do
    before do
      CustomOrganisationName.create(name: 'DummyOrg2')
      sign_in_user admin_user
      visit admin_custom_organisations_path
    end

    it 'will remove the custom org from the register' do
      click_link 'Remove'
      expect {
        click_on 'Yes, remove this organisation'
      }.to change { CustomOrganisationName.count }.by(-1)
    end
  end
end
