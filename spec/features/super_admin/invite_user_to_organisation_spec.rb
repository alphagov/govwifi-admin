require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe "Inviting a team member as a super admin", focus: true, type: :feature do
  let(:super_admin) { create(:user, super_admin: true) }
  let(:organisation) { create(:organisation) }

  before do
    sign_in_user super_admin
    visit admin_organisation_path(organisation)
  end

  context "when visiting a specific organisations show page" do
    it "will give the super admin the ability to click on invite a team member" do
      expect(page).to have_content("Invite team member")
    end
  end
end
