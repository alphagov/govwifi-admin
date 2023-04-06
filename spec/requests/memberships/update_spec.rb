describe "PATCH /memberships/:id", type: :request do
  let(:new_permission_level) { "view_only" }
  let(:user) { create(:user, :with_organisation) }
  let(:first_team_member) { create(:user, organisations: user.organisations) }
  let(:membership) { first_team_member.memberships.first }

  before do
    https!
    sign_in_user(user)
  end
  context "when the membership has been confirmed, the user is an administrator and there is one admin user" do
    it "redirects" do
      membership.update!(confirmed_at: Time.zone.now)
      expect {
        patch membership_path(membership), params: { permission_level: new_permission_level }
      }.to raise_error(ActionController::RoutingError, "Not Found")
    end
  end

  context "when validate_has_two_confirmed_admin_users is false" do
    it "updates the membership" do
      patch membership_path(membership), params: { permission_level: new_permission_level }
      expect(response).to redirect_to(memberships_path)
      expect(flash[:notice]).to eq("Permissions updated")

      membership.reload
      expect(membership.permission_level).not_to eq("administrator")
      expect(membership.can_manage_team).to be false
      expect(membership.can_manage_locations).to be false
    end
  end
end
