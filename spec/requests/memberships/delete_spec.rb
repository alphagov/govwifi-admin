describe "DELETE /memberships/:id", type: :request do
  let(:user) { create(:user, :with_organisation) }
  let!(:team_member) { create(:user, organisations: user.organisations) }

  before do
    https!
    sign_in_user(user)
  end

  context "when the user has permissions to delete a team member" do
    it "deletes the team membership" do
      membership = team_member.memberships.first
      expect {
        delete membership_path(membership)
      }.to change(Membership, :count).by(-1)
    end
  end

  context "when the team member belongs to another team" do
    let(:other_team_member) { create(:user, :with_organisation) }

    it "raises an error" do
      membership = other_team_member.memberships.first
      expect {
        delete membership_path(membership)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when the user is a super admin" do
    let(:user) { create(:user, :super_admin) }
    let!(:other_team_member) { create(:user, :with_organisation) }

    it "deletes the team membership" do
      membership = other_team_member.memberships.first
      expect {
        delete membership_path(membership)
      }.to change(Membership, :count).by(-1)
    end
  end

  context "when deleting the only membership for a user" do
    let(:user) { create(:user, :super_admin) }
    let!(:other_team_member) { create(:user, organisations: [create(:organisation)]) }

    it "deletes the team membership and the user" do
      membership = other_team_member.memberships.first
      expect {
        delete membership_path(membership)
      }.to change(Membership, :count).by(-1).and change(User, :count).by(-1)
    end
  end
end
