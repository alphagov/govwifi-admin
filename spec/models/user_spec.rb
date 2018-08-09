RSpec.describe User do
  describe "#attempt_set_password" do
    let(:user) { create(:user, password: "password") }
    context "when passwords match" do
      let(:params) { { password: "12345678", password_confirmation: "12345678" } }

      it "should set the users password" do
        expect { user.attempt_set_password(params) }.to change(user, :password)
        expect(user.errors.empty?).to eq(true)
      end
    end

    context "when passwords do not match" do
      let(:params) { { password: "12345678", password_confirmation: "123456789" } }

      it "should not set the users password" do
        expect { user.attempt_set_password(params) }.to_not change(user, :password)
        expect(user.errors.empty?).to eq(false)
        expect(user.errors.full_messages).to eq(["Passwords must match"])
      end
    end
  end
end
