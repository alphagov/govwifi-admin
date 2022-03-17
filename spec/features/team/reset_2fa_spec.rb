describe "Reset two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }

  let(:org_admin_user_1) { create(:user, :with_2fa, organisations: [organisation]) }
  let(:org_admin_user_2) { create(:user, :with_2fa, organisations: [organisation]) }
  let(:org_admin_user_3) { create(:user, organisations: [organisation]) } # no 2fa

  let(:super_admin_user) { create(:user, :super_admin, :with_2fa) }

  context "when logged in as a super admin user" do
    before do
      sign_in_user(super_admin_user)
      org_admin_user_1 # explicit call to avoid lazy-evaluation
    end

    it "only shows the option to reset 2FA for org members who have 2FA enabled" do
      visit super_admin_organisation_path(organisation)

      expect(page).to have_content("Reset 2FA", count: 1)
    end

    it "shows confirmation before resetting 2FA for an org member" do
      visit super_admin_organisation_path(organisation)
      click_on "Reset 2FA"

      expect(page).to have_content("Are you sure you want to reset")
    end

    it "resets 2FA for an org member once super admin confirms the reset" do
      visit super_admin_organisation_path(organisation)
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"

      expect(org_admin_user_1.reload.totp_enabled?).to be false
    end

    it "redirects back to org listing once 2FA has been reset" do
      visit super_admin_organisation_path(organisation)
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"

      expect(page).to have_current_path(super_admin_organisations_path)
    end

    it "shows a notice once 2FA has been reset" do
      visit super_admin_organisation_path(organisation)
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"

      expect(page).to have_content("Two factor authentication has been reset")
    end
  end

  context "when logged in as an org admin user" do
    before do
      org_admin_user_1
      sign_in_user(org_admin_user_2)
    end

    it "only shows the option to reset 2FA for org members who have 2FA enabled" do
      visit memberships_path

      # Not 2, because "Reset 2FA" link does not show for the current user.
      expect(page).to have_content("Reset 2FA", count: 1)
    end

    it "shows confirmation before resetting 2FA for an org member" do
      visit memberships_path
      click_on "Reset 2FA"

      expect(page).to have_content("Are you sure you want to reset")
    end

    it "resets 2FA for an org member once org admin user confirms the reset" do
      visit memberships_path
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"

      expect(org_admin_user_1.reload.totp_enabled?).to be false
    end

    it "redirects back to members listing once 2FA has been reset" do
      visit memberships_path
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"
      expect(page).to have_current_path(memberships_path)
    end

    it "shows a notice once 2FA has been reset" do
      visit memberships_path
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"
      expect(page).to have_content("Two factor authentication has been reset")
    end
  end
end
