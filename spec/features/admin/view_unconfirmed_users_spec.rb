require 'support/notifications_service'

describe 'viewing all unconfirmed users' do
  include_examples 'notifications service'

  let(:admin_user) { create(:user, super_admin: true) }

  let!(:unconfirmed_user_1) { create(:user, confirmed_at: nil) }
  let!(:unconfirmed_user_2) { create(:user, confirmed_at: nil) }
  let!(:confirmed_user) { create(:user) }

  context 'when visiting the manage users page' do
    before do
      sign_in_user admin_user
      visit admin_manage_users_path
    end

    it 'should show the user the manage users page' do
      expect(page).to have_content("Manage Users")
    end

    it 'lists only the unconfirmed users' do
      expect(page).to have_content(unconfirmed_user_1.email)
      expect(page).to have_content(unconfirmed_user_2.email)
      expect(page).to_not have_content(confirmed_user.email)
    end
  end
end
