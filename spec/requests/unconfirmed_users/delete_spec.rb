describe "DELETE /admin_manage_users/:id", type: :request do
  before do
    stub_request(:post, "https://api.notifications.service.gov.uk/v2/notifications/email").
    to_return(status: 200, body: "{}", headers: {})
  end

  let!(:unconfirmed_user) { create(:user, confirmed_at: nil) }

  context "when the user is a super admin" do
    before do
      https!
      sign_in_user(create(:user, super_admin: true))
    end

    it "deletes the unconfirmed user" do
      expect {
        delete admin_manage_user_path(unconfirmed_user)
      }.to change { User.count }.by(-1)
    end
  end

  context "when the user is not super admin" do
    before do
      https!
      sign_in_user(create(:user, super_admin: false))
    end

    it "does not delete the email domain" do
      expect {
        delete admin_manage_user_path(unconfirmed_user)
      }.to change { User.count }.by(0)
    end
  end
end
