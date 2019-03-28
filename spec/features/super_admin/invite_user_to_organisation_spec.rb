require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe "Inviting a team member as a super admin", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:super_admin) { create(:user, super_admin: true) }

  before do
    create(:user, organisation: organisation)
    sign_in_user super_admin
    visit admin_organisation_path(organisation)
  end

  context "when visiting a specific organisations show page" do
    it "will give the super admin the ability to click on invite a team member" do
      expect(page).to have_content("Add team member")
    end
  end
end
