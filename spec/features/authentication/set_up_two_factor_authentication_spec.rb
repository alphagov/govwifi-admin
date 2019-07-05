describe "Set up two factor authentication", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:super_admin_organisation) { create(:organisation, super_admin: true) }
  let(:user) { create(:user, organisations: [super_admin_organisation]) }

  before do
    visit users_sign_in_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Continue"
  end

  context "with a super admin user" do
    it "2FA setup is enforced" do
      expect(page).to have_content("Forgot your password?")
    end

    it "presents a QR code" do
    end

    it "expects a TOTP code" do
    end

    context "submitting a valid code" do
      it "authenticates the user" do
      end
    end

    context "submitting an invalid code" do
      it "returns an error" do
      end

      it "returns to the 2FA screen" do
      end

      it "doesn't store a totp for the user" do
      end
    end
  end

  context "with a normal admin user" do
    let(:user) { create(:user, organisations: [organisation]) }

    it "2FA setup is not enforced" do
    end
  end
end
