require 'support/notifications_service'

describe 'deleting an unconfirmed user' do
  include_examples 'notifications service'

  let!(:admin_user) { create(:user, super_admin: true) }
  let!(:unconfirmed_user) { create(:user, confirmed_at: nil) }

  context 'when visiting the manage users page' do
    before do
      sign_in_user admin_user
      visit admin_manage_users_path
      click_on "Remove user"
    end

    it 'prompts with a flash message to remove the user' do
      expect(page).to have_content("Are you sure you want to delete this unconfirmed user")
      expect(page).to have_button("Yes, remove the user")
    end

    it "deletes the user" do
      expect { click_on "Yes, remove the user" }.to change { User.count }.by(-1)
    end
  end
end
