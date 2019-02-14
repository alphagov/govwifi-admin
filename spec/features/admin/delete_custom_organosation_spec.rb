require 'support/confirmation_use_case'

describe 'adding a custom organisation name' do
  include_examples 'confirmation use case spy'

  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the custom organisations page' do
    before do
      sign_in_user admin_user
      CustomOrganisationName.create(name: 'Custom Org1')
      visit admin_custom_organisations_path
    end

    it 'allows the user to delete a custom organisation' do
      click_link 'Remove'
      click_on 'Yes, remove this organisation'
      expect(page).to have_content("Successfully removed Custom Org1")
    end

    it 'will remove the custom org from the register' do
      click_link 'Remove'
      expect {
        click_on 'Yes, remove this organisation'
      }.to change { CustomOrganisationName.count }.by(-1)
    end
  end
end
