describe "DELETE /team_members/:id", type: :request do
  let(:user) { create(:user, :with_organisation) }
  let!(:team_member) { create(:user, organisations: [user.organisations.first]) }

  before do
    https!
    login_as(user, scope: :user)
  end

  context "when the user has permissions to delete a team member" do
    it "deletes the team member" do
      expect {
        delete team_member_path(team_member)
      }.to change(User, :count).by(-1)
    end
  end

  context "when the team member belongs to another team" do
    let!(:other_team_member) { create(:user) }

    it "does not delete the user" do
      expect {
        delete team_member_path(other_team_member)
      }.to change(User, :count).by(0)
    end
  end
end
