describe 'deleting an organisation' do
  let!(:admin_user) { create(:user, super_admin: true) }
  let!(:organisation) { create(:organisation, name: 'Gov Org 2') }

  context 'when visiting the organisations page' do
    before do
      sign_in_user admin_user
      visit admin_organisation_path(organisation)
      click_on 'Delete organisation'
    end

    it 'shows the organisations page I am on' do
      expect(page).to have_content("Gov Org 2")
    end

    it 'should show a delete organisation button on the page' do
      expect(page).to have_content("Delete organisation")
    end

    it 'should prompt with a flash message to delete the organisation' do
      expect(page).to have_content("Are you sure you want to delete")
    end

    it 'should notify the user when a organsiation has been deleted' do
      click_on 'Yes, remove this organisation'
      expect(page).to have_content("Organisation has been removed")
    end

    it 'should remove the organisation from the index list of orgs' do
      click_on 'Yes, remove this organisation'
      expect(page).to_not have_content("Gov Org 2")
    end
  end
end
