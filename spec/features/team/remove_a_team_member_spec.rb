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
    before do
      sign_in_user user
      visit root_path
      click_on "Edit permissions"
      click_on "Remove team member"
    end

    it "shows an alert when removing a team member" do
      expect(page).to have_content("Are you sure you want to remove")
    end
  end
end

