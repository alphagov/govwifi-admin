require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'view details of a signed up organisations' do
  let!(:organisation) { create(:organisation) }

  context 'when logged out' do
    before { visit organisations_path(organisation) }

    it_behaves_like 'not signed in'
  end

  context "when logged in" do
    let!(:user) { create(:user, :confirmed, admin: true) }

    it 'shows details page for the organisations' do
      sign_in_user user
      visit organisations_path(organisation)

      expect(page).to have_content(organisation.name)
    end
  end
end
