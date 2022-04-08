describe "Remove a team member", type: :feature do
  let!(:organisation) { create(:organisation) }
  let!(:user) { create(:user, organisations: [organisation]) }
  let!(:another_user) { create(:user, organisations: [organisation]) }

  before do
    sign_in_user user
  end

  context "with the correct permissions" do
    before do
      visit edit_membership_path(another_user.membership_for(organisation))
      click_on "Remove user from GovWifi admin"
    end

    it "shows the remove a team member confirmation box" do
      expect(page).to have_content("Are you sure you want to remove")
    end

    it "hides the delete user link when already clicked" do
      expect(page).not_to have_content("Remove user from service")
    end

    it "deletes the membership" do
      expect { click_on "Yes, remove this team member" }.to change(Membership, :count).by(-1)
    end

    it 'redirects to "after user removed" team members page for analytics' do
      click_on "Yes, remove this team member"
      expect(page).to have_current_path("/memberships")
    end
  end

  context "without correct permissions" do
    before do
      user.membership_for(organisation).update!(can_manage_team: false)
    end

    context "when visiting remove team member url directly" do
      it "does not show the page" do
        expect {
          visit edit_membership_path(another_user.membership_for(organisation), remove_team_member: true)
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
