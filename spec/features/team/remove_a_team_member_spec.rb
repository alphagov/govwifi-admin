require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe "Remove a team member" do
  include_examples 'invite use case spy'
  include_examples 'notifications service'

  context "when logged in" do
    let(:user) { create(:user, :confirmed) }
    let!(:another_user) { create(:user, organisation: user.organisation) }

    before do
      sign_in_user user
      visit edit_permission_path(user)
      click_on "Remove user from service"
    end

    it "shows an alert when removing a team member" do
      expect(page).to have_content("Are you sure you want to remove")
    end

    it 'does not have delete user link when already clicked' do
      expect(page).to_not have_content("Remove user from service")
    end
  end
end

