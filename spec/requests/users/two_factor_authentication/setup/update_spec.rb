describe "PUT /users/two_factor_authentication/setup/:method", type: :request do
  let(:organisation) { create(:organisation) }

  before do
    https!
    @user = create(:user, :with_2fa, organisations: [organisation])
    sign_in_user(@user)
    totp_double = double(ROTP::TOTP)
    allow(ROTP::TOTP).to receive(:new).and_return(totp_double)
    allow(totp_double).to receive(:verify).and_return(true)
  end

  context "'email' is passed as the 2FA method'" do
    it "saves 'email' as the 2FA method" do
      put "/users/two_factor_authentication/setup", params: { method: "email" }
      expect(@user.reload.second_factor_method).to eq("email")
    end
  end

  context "nonsense is passed as the 2FA method'" do
    it "saves 'app' as the 2FA method" do
      put "/users/two_factor_authentication/setup", params: { method: "blah", code: "a_code" }
      expect(@user.reload.second_factor_method).to_not eq("blah")
    end
  end

  context "'app' is passed as the 2FA method" do
    it "saves 'app' as the 2FA method" do
      put "/users/two_factor_authentication/setup", params: { method: "app", code: "a_code" }
      expect(@user.reload.second_factor_method).to eq("app")
    end
  end
end
