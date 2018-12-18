describe 'editing an organisations details' do
  let(:admin_user1) { create(:user, organisation: organisation) }
  let(:organisation) { create(:organisation, name: "TestMe & Company", service_email: "testme@gov.uk") }

  context 'when visiting the organisations settings page before any changes' do
    before do
      sign_in_user admin_user1
      visit organisation_path(organisation)
    end

    it 'has the current company name and service email' do
      expect(page).to have_content("TestMe & Company")
      expect(page).to have_content("testme@gov.uk")
    end
  end

  context 'when visiting the edit organisations settings page' do
    before do
      sign_in_user admin_user1
      visit edit_organisation_path(organisation)
    end

    it 'allows the user to change their company name and service email' do
      fill_in 'Organisation name', with: "New Company Name"
      fill_in 'Service email', with: "NewServiceEmail@gov.uk"
      click_on 'Save'
      expect(page).to have_content("New Company Name")
      expect(page).to have_content("NewServiceEmail@gov.uk")
      expect(page).to have_content("Organisation updated")
      expect(page).to have_content("Organisation Settings")
    end
  end

  context 'a user from an organisation tries to change another organisations details' do
    let(:admin_user2) { create(:user) }
    before do
      sign_in_user admin_user1
    end

    it 'will display a routing error' do
      expect {
        visit edit_organisation_path(admin_user2.organisation)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
