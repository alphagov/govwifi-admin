require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'

describe 'signing as an admin user' do
  let!(:user) { create(:user, admin: true) }

  context 'when visiting the home page' do
    before do
      create(:organisation, name: "TestMe & Company")
      sign_in_user user
      visit root_path
    end

    it 'shows list of signed organisations on the home page' do
      expect(page).to have_content("TestMe & Company")
    end
  end
end
