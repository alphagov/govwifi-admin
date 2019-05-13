require 'rack_session_access/capybara'

describe 'Multiple organisations', type: :feature do
  let!(:other_organisation) { create(:organisation) }
  let(:user) { create(:user, :with_organisation) }
  let(:organisation) { user.organisations.first }

  before do
    sign_in_user user
  end

  context "when an organisation_id session is set" do
    context "when the user doesn't belong to the organisation in the session" do
      it 'dissallows switching to that organisation' do
        page.set_rack_session(organisation_id: other_organisation.id)

        visit root_path
        expect(page).not_to have_content(other_organisation.name)
      end
    end

    context "when the user belongs to the organisation in the session" do
      it 'allows switching to that organisation' do
        page.set_rack_session(organisation_id: organisation.id)

        visit root_path
        expect(page).to have_content(organisation.name)
      end
    end
  end
end
