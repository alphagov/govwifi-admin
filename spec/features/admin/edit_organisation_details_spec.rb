require 'features/support/sign_up_helpers'

describe 'editing an organisations details' do
  let!(:admin_user) { create(:user, organisation: organisation) }
  let!(:organisation) { create(:organisation, name: "TestMe & Company", service_email: "testme@gov.uk") }

  context 'when visiting the organisations settings page before any changes' do
    before do
      sign_in_user admin_user
      visit organisation_path(organisation)
    end

    it 'has the current compnay name and service email' do
      expect(page).to have_content("Organisation Name: TestMe & Company")
      expect(page).to have_content("Service Email: testme@gov.uk")
    end
  end

  context 'when visiting the edit organisations settings page' do
    before do
      sign_in_user admin_user
      visit edit_organisation_path(organisation)
    end

    it 'allows the user to change their company name and service email' do
      fill_in 'org-name', with: "New Company Name"
      fill_in 'org-service-email', with: "NewServiceEmail@gov.uk"
      click_on 'Save'
      expect(page).to have_content("Organisation Name: New Company Name")
      expect(page).to have_content("Service Email: NewServiceEmail@gov.uk")
    end
  end
end
