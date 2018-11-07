require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'

describe 'signing as an admin user' do
  let!(:user) { create(:user, :confirmed, admin: true) }

  context 'when visiting the home page' do
    before do
      5.times { create(:organisation) }
      sign_in_user user
      visit root_path
    end

    it 'redirects to the organisations page' do
      expect(page.current_path).to eq(organisations_path)
    end

    it 'shows list of signed organisations on the home page' do
      Organisation.all.each do |organisation|
        expect(page).to have_content(organisation.name)
      end
    end
  end
end
