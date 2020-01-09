describe "Reset two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:org_admin_user_1) { create(:user, organisations: [organisation]) }
  let(:org_admin_user_2) { create(:user, organisations: [organisation]) }
  let(:org_admin_user_3) { create(:user, organisations: [organisation]) }

  let(:super_admin_organisation) { create(:organisation, super_admin: true) }
  let(:super_admin_user) { create(:user, organisations: [super_admin_organisation]) }

  before do
    # Disabling Rubocop check for this as can't figure out a reliable way to stub instance method
    # for user objects.
    allow_any_instance_of(User).to receive(:need_two_factor_authentication?).and_return(true) # rubocop:disable RSpec/AnyInstance
  end

  context "when logged in as a super admin user" do
    let(:totp_double) { instance_double(ROTP::TOTP) }

    before do
      allow(ROTP::TOTP).to receive(:new).and_return(totp_double)
      allow(totp_double).to receive(:verify).and_return(true)
      allow(totp_double).to receive(:provisioning_uri).and_return("blah")

      # Log in org admin just so 2FA is enabled for their account.
      sign_in_user(org_admin_user_1, pass_through_two_factor: false)
      visit root_path
      fill_in :code, with: '999999'
      click_on "Complete setup"

      sign_out

      sign_in_user(super_admin_user, pass_through_two_factor: false)
      visit root_path
      fill_in :code, with: '999999'
      click_on "Complete setup"
    end

    it "only shows the option to reset 2FA for org members who have 2FA enabled" do
      visit super_admin_organisation_path(organisation)

      expect(page).to have_content("Reset 2FA", count: 1)
    end

    it "shows confirmation before resetting 2FA for an org member" do
      visit super_admin_organisation_path(super_admin_organisation)
      click_on "Reset 2FA"

      expect(page).to have_content("Are you sure you want to reset")
    end

    it "resets 2FA for an org member once super admin confirms the reset" do
      visit super_admin_organisation_path(super_admin_organisation)
      click_on "Reset 2FA"
      click_on "Yes, reset two factor authentication"

      expect(super_admin_user.reload.totp_enabled?).to be false
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
    let(:totp_double) { instance_double(ROTP::TOTP) }

    before do
      allow(ROTP::TOTP).to receive(:new).and_return(totp_double)
      allow(totp_double).to receive(:verify).and_return(true)
      allow(totp_double).to receive(:provisioning_uri).and_return("blah")

      sign_in_user(org_admin_user_1, pass_through_two_factor: false)
      visit root_path
      fill_in :code, with: '999999'
      click_on "Complete setup"

      sign_out

      sign_in_user(org_admin_user_2, pass_through_two_factor: false)
      visit root_path
      fill_in :code, with: '999999'
      click_on "Complete setup"
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
