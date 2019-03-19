require 'support/notifications_service'

describe 'viewing all unconfirmed users' do
  let!(:confirmed_user) { create(:user, email: "test5@gov.uk", organisation: organisation) }
  let!(:unconfirmed_user_2) { create(:user, email: "test3@gov.uk", confirmed_at: nil) }
  let!(:unconfirmed_user_3) { create(:user, email: "test4@gov.uk", confirmed_at: nil) }
  let!(:unconfirmed_user_1) { create(:user, email: "test2@gov.uk", confirmed_at: nil) }
  let(:admin_user) { create(:user, email: "admin@gov.uk", super_admin: true, organisation: organisation) }
  let(:organisation) { create(:organisation) }

  include_examples 'notifications service'




  context 'when visiting the manage users page' do
    before do
      sign_in_user admin_user
      visit admin_manage_users_path
    end

    it 'shows the user the manage users page' do
      expect(page).to have_content("Manage Users")
    end

    it 'lists only the unconfirmed users' do
      expect(page).to have_content(unconfirmed_user_1.email)
      expect(page).to have_content(unconfirmed_user_2.email)
      expect(page).to have_content(unconfirmed_user_3.email)
      expect(page).not_to have_content(confirmed_user.email)
    end

    it 'displays the list of all unconfirmed users in alphabetical order' do
      expect(page.body).to match(/test2@gov.uk.*test3@gov.uk.*test4@gov.uk/m)
    end
  end
end
