require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe 'viewing all unconfirmed users' do
  include_examples 'invite use case spy'
  include_examples 'notifications service'

  let!(:admin_user) { create(:user, super_admin: true) }

  let!(:organisation) { create(:organisation) }

  let!(:unconfirmed_user1) { create(:user, confirmed_at: nil, email: "unconfirmed_user1@gov.uk") }
  let!(:unconfirmed_user2) { create(:user, confirmed_at: nil, email: "unconfirmed_user2@gov.uk") }

  let!(:confirmed_user1) { create(:user, confirmed_at: Time.now, email: "person1@gov.uk", organisation: organisation) }
  let!(:confirmed_user2) { create(:user, confirmed_at: Time.now, email: "person2@gov.uk", organisation: organisation) }

  context 'when visiting the manage users page' do
    before do
      sign_in_user admin_user
      visit admin_manage_users_path
    end

    it 'should show the user the manage users page' do
      expect(page).to have_content("Manage Users")
    end

    it 'lists only the unconfirmed users' do
      expect(page).to have_content("unconfirmed_user1@gov.uk")
      expect(page).to have_content("unconfirmed_user2@gov.uk")

      expect(page).to_not have_content("person1@gov.uk")
      expect(page).to_not have_content("person2@gov.uk")
    end
  end
end
