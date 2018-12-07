require 'features/support/sign_up_helpers'

describe 'deleting an organisation', focus: true do
  let!(:admin_user) { create(:user, super_admin: true) }
  let!(:organisation) { create(:organisation, name: "TestMe & Company") }

  context 'when visiting the organisations page' do
    before do
      sign_in_user admin_user
      visit admin_organisation_path(organisation)
      click_on 'Delete organisation'
    end

    it 'shows the organisations page I am on' do
      expect(page).to have_content("TestMe & Company")
    end

    it 'should show a delete organisation button on the page' do
      expect(page).to have_content("Delete organisation")
    end

    it 'should prompt with a flash message to delete the organisation' do
      expect(page).to have_content("Are you sure you want to delete this organisation?")
    end

  end
end
