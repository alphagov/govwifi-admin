require "support/invite_use_case"
require "support/confirmation_use_case"

describe "Inviting an existing user which belongs to an organisation", type: :feature do
  include_context "when using the notifications service"

  let!(:organisation) { create(:organisation) }
  let!(:user) { create(:user, organisations: [organisation]) }

  let!(:organisation_2) { create(:organisation) }
  let!(:user_2) { create(:user, email: "inviteme@gov.uk", organisations: [organisation_2]) }

  context "with a user that already belongs to an organisation" do
    before do
      sign_in_user user
      visit memberships_path
      click_on "Invite a team member"
      fill_in "Email", with: user_2.email
      click_on "Send invitation email"
    end

    it "will show pending users which have been invited to an organisation" do
      expect(page).to have_content("#{user_2.name} (invited)")
    end
  end
end
