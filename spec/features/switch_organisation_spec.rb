require 'rack_session_access/capybara'

describe 'Multiple organisations', type: :feature do
  let!(:other_organisation) { create(:organisation) }
  let(:user) { create(:user, organisation: create(:organisation)) }

  before do
    sign_in_user user
  end

  context "when the user doesn't belong to that organisation" do
    it 'dissallows switching to that organisation' do
      page.set_rack_session(organisation_id: other_organisation.id)

      visit root_path
      expect(page).not_to have_content(other_organisation.name)
    end
  end
end
