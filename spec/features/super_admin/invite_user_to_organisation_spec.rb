require 'support/invite_use_case'
require 'support/notifications_service'

describe "Inviting a team member as a super admin", focus: true, type: :feature do
  include_examples 'notifications service'

  let(:organisation) { create(:organisation, name: "Gov Org 3") }
  let(:super_admin) { create(:user, super_admin: true) }

  before do
    sign_in_user super_admin
    visit admin_organisation_path(organisation)
    click_on 'Add team member'
    fill_in 'Email address', with: 'barry@gov.uk'
  end

    it "will take the user back to the organisation when they click back to organisation" do
      click_on 'Back to organisation'
      expect(page).to have_current_path(admin_organisation_path(organisation))
    end

    it "will give the give the name of the organisation you want to add a team member to" do
      expect(page).to have_content("Invite a team member to #{organisation.name}")
    end

    it "creates the user" do
      expect{ click_on 'Send invitation email' }.to change(User, :count).by(1)
    end

    it "adds the user to the correct organisation" do
      click_on 'Send invitation email'
      user = User.find_by(email: 'barry@gov.uk')
      expect(user.organisation).to eq(organisation)
    end

    it "will redirect the user to the organisation page" do
      click_on 'Send invitation email'
      expect(page).to have_current_path(admin_organisation_path(organisation))
    end
  end
