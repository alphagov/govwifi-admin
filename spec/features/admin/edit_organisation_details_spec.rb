describe 'editing an organisations details' do
  let(:user) { create(:user, organisation: organisation) }
  let(:organisation) { create(:organisation, name: "TestMe & Company", service_email: "testme@gov.uk") }

  context 'when visiting the organisations settings page before any changes' do
    before do
      sign_in_user user
      visit settings_path
    end

    it 'has the current company name and service email' do
      expect(page).to have_content("TestMe & Company")
      expect(page).to have_content("testme@gov.uk")
    end
  end

  context 'when visiting the edit organisations settings page' do
    before do
      sign_in_user user
      visit edit_organisation_path(organisation)
    end

    it 'allows the user to change their company name and service email' do
      fill_in 'Organisation name', with: "New Company Name"
      fill_in 'Service email', with: "NewServiceEmail@gov.uk"
      click_on 'Save'
      expect(page).to have_content("New Company Name")
      expect(page).to have_content("NewServiceEmail@gov.uk")
      expect(page).to have_content("Organisation updated")
    end
  end

  context 'when you belong to a different organisation' do
    let(:other_user) { create(:user) }

    before { sign_in_user create(:user) }

    it 'will display a routing error' do
      expect {
        visit edit_organisation_path(other_user.organisation)
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
