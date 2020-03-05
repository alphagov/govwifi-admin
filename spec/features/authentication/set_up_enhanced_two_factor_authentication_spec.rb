describe "Set up two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:super_admin_organisation) { create(:organisation, super_admin: true) }
  let(:user) { create(:user, organisations: [super_admin_organisation]) }

  before do
    allow(Rails.application.config).to receive(:enable_enhanced_2fa_experience).and_return true
    sign_in_user(user, pass_through_two_factor: false)
    visit root_path
  end

  context "when admin user has not configured 2FA yet" do
    it "presents the setup page" do
      expect(page).to have_current_path("/users/two_factor_authentication/setup")
    end

    it "explains the setup step" do
      expect(page).to have_content("Set up two-factor authentication")
    end

    it "provides the option to receive security codes via email" do
      expect(page).to have_css("#email")
    end

    it "provides the option to generate security codes by authentication app" do
      expect(page).to have_css("#app")
    end
  end
end
