require 'features/support/sign_up_helpers'

describe "Remove a team member" do
  let(:user) { create(:user, :confirmed) }
  let(:another_user) { create(:user, :confirmed, organisation: user.organisation) }

  before do
    sign_in_user user
  end

  context "with the correct permissions" do
    before do
      visit edit_team_member_path(another_user)
      click_on "Remove user from service"
    end

    it "shows the remove a team member confirmation box" do
      expect(page).to have_content("Are you sure you want to remove")
    end

    it "hides the delete user link when already clicked" do
      expect(page).to_not have_content("Remove user from service")
    end

    it "deletes the user" do
      expect { click_on "Yes, remove this team member" }.to change { User.count }.by(-1)
    end
  end

  context "without correct permissions" do
    before do
      user.permission.update!(can_manage_team: false)
    end

    context "when visiting remove team member url directly" do
      it 'should not show the page' do
        expect {
          visit edit_team_member_path(another_user, remove_team_member: true)
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
