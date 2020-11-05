require "support/notifications_service"

describe User do
  let(:organisation) { create(:organisation) }

  include_context "when using the notifications service"

  describe "validation" do
    let(:user) { create(:user) }
    let(:pw) { "this is 333 a strong !!! password" }

    it "has a valid factory user" do
      expect(user).to be_valid
    end

    ["password123", "my password", "pa55w0rd"].each do |weak_pass|
      it "does not accept a weak password (#{weak_pass})" do
        user.update(password: weak_pass)

        expect(user).not_to be_valid
      end

      it "accepts a strong password" do
        user.update(password: pw)

        expect(user).to be_valid
      end

      it "checks for a password confirmation field" do
        user.update(password: pw, password_confirmation: pw.reverse)

        expect(user).not_to be_valid
      end
    end
  end

  it { is_expected.to have_many(:organisations).through(:memberships) }
  it { is_expected.to have_many(:memberships) }
  it { is_expected.to validate_presence_of(:name).on(:update) }

  context "when checking if a membership is pending" do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:organisation) { create(:organisation) }

    it "returns true if the membership is pending" do
      expect(user.pending_membership_for?(organisation: organisation)).to eq(true)
    end
  end

  describe ".super_admin?" do
    let(:superorg) { create(:organisation, super_admin: true) }
    let(:user) { create(:user) }

    describe "when the user is part of the superadmin org" do
      it "is true" do
        user.organisations << superorg

        expect(user).to be_super_admin
      end
    end

    context "when the user has the superadmin attribute" do
      it "is true" do
        user.update!(is_super_admin: true)

        expect(user).to be_super_admin
      end
    end

    context "when the user is not part of the superadmin org" do
      it "is false" do
        user.organisations << organisation

        expect(user).not_to be_super_admin
      end
    end

    context "when the user is not superadmin" do
      it "is false" do
        expect(user).not_to be_super_admin
      end
    end
  end

  describe ".new_super_admin?" do
    let(:user) { create(:user, :new_admin) }

    context "with no organisations memberships" do
      it "returns true" do
        expect(user).to be_new_super_admin
      end
    end

    context "with a membership" do
      it "returns false" do
        user.organisations << create(:organisation)

        expect(user).not_to be_new_super_admin
      end
    end
  end

  describe ".default_membership" do
    context "with no memberships" do
      let(:user) { create(:user) }

      it "returns nil" do
        expect(user.default_membership).to eq(nil)
      end
    end

    context "with memberships" do
      let(:organisation_1) { create(:organisation) }
      let(:organisation_2) { create(:organisation) }
      let(:user) { create(:user, organisations: [organisation_1]) }

      before do
        user.organisations << organisation_2
      end

      it "returns the first one" do
        expect(user.default_membership).to eq(user.membership_for(organisation_1))
      end
    end
  end

  describe "need_two_factor_authentication?" do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:warden) { instance_double(Warden::Proxy, user: subject) }
    let(:request) { instance_double(ActionDispatch::Request, env: { "warden" => warden }) }
    let(:organisation) { create(:organisation) }

    before do
      allow(warden).to receive(:session).with(:user) { Hash[two_factor_session_key => nil] }
    end

    context "with super admins membership" do
      let(:organisation) { create(:organisation, super_admin: true) }

      it "is true" do
        expect(user.need_two_factor_authentication?(request)).to be true
      end
    end

    context "with a normal admin user" do
      it "is true" do
        expect(user.need_two_factor_authentication?(request)).to be true
      end
    end

    context "when skipped for later" do
      it "is false" do
        allow(warden).to receive(:session).with(:user) { Hash[two_factor_session_key => false] }

        expect(user.need_two_factor_authentication?(request)).to be false
      end
    end

    context "when bypassed with an environment variable" do
      let(:organisation) { create(:organisation, super_admin: true) }

      before { allow(ENV).to receive(:key?).with("BYPASS_2FA").and_return(true) }

      it "is false" do
        expect(user.need_two_factor_authentication?(request)).to be false
      end
    end
  end

  describe "can_manage_other_user_for_org?" do
    let(:organisation) { create(:organisation) }

    let(:superadmin) { create(:user, :new_admin) }
    let(:admin) { create(:user, organisations: [organisation]) }
    let(:user) { create(:user, organisations: [organisation]) }
    let(:colleague) { create(:user, organisations: [organisation]) }

    context "when the operator is a super admin" do
      it "returns true" do
        expect(superadmin.can_manage_other_user_for_org?(user, organisation))
          .to be true
      end
    end

    context "when the operator is not entitled to manage the team" do
      before do
        colleague.membership_for(organisation).update!(can_manage_team: false)
      end

      it "returns false" do
        expect(colleague.can_manage_other_user_for_org?(user, organisation))
          .to be false
      end
    end

    context "when the operator can manage the team" do
      it "returns true" do
        expect(admin.can_manage_other_user_for_org?(user, organisation))
          .to be true
      end
    end

    context "when the user is not part of the same org" do
      it "returns false" do
        expect(admin.can_manage_other_user_for_org?(create(:user, :with_organisation), organisation))
          .to be false
      end
    end

    context "when the operator is not part of the same org" do
      it "returns false" do
        expect(create(:user, :with_organisation).can_manage_other_user_for_org?(user, organisation))
          .to be false
      end
    end
  end

  describe "reset_2fa!" do
    let(:user) { create(:user, :with_2fa) }

    before do
      user.reset_2fa!
    end

    it "resets the two factor auth" do
      expect(user).not_to be_totp_enabled
    end
  end

  describe "#send_new_otp_after_login?" do
    it "it sends an email if the user has chosen to 2fa through email" do
      user = create(:user, :with_organisation, second_factor_method: "email")
      expect(user.send_new_otp_after_login?).to be true
    end

    it "does not send an email if the user has chosen to 2fa through the app" do
      user = create(:user, :with_organisation, second_factor_method: "app")
      expect(user.send_new_otp_after_login?).to be false
    end
  end

  describe "#send_new_otp" do
    let(:user) { create(:user, :with_organisation) }
    context "the user has a direct otp set" do
      before :each do
        user.create_direct_otp
        user.send_new_otp
      end

      it "sends an email" do
        expect(notification_instance).to have_received(:send_email).
                with(hash_including(personalisation:
                                        {
                                            name: user.name,
                                            url: "https://example.com/users/two_factor_authentication/auth/#{user.direct_otp}",
                                        }))
      end
    end
  end

  describe ".has_2fa?" do
    let(:no_2fa) { create(:user) }
    let(:app_2fa) { create(:user, :with_2fa) }
    let(:email_2fa) { create(:user, :with_email_2fa) }

    context "when no 2fa" do
      it "returns false" do
        expect(no_2fa.has_2fa?).to be false
      end
    end

    context "when app 2fa" do
      it "returns true" do
        expect(app_2fa.has_2fa?).to be true
      end
    end

    context "when email 2fa" do
      it "returns true" do
        expect(email_2fa.has_2fa?).to be true
      end
    end
  end
end
