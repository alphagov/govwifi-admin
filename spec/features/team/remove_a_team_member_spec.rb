describe "Remove a team member", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:second_user) { create(:user, organisations: [organisation]) }
  let(:third_user) { create(:user, organisations: [organisation]) }

  before do
    user.membership_for(organisation).update!(can_manage_team: true)
    second_user.membership_for(organisation).update!(can_manage_team: true)
    user.membership_for(organisation).confirm!
    second_user.membership_for(organisation).confirm!
    sign_in_user user
  end

  context "with the correct permissions" do
    context "when there are less than three confirmed admin users in the organisation" do
      before do
        visit edit_membership_path(second_user.membership_for(organisation))
        click_on "Remove user from GovWifi admin"
      end

      it "shows an error" do
        expect(page).to have_content("There is a problem\nYou must add another administrator before you can remove #{second_user.name}.")
      end
    end

    context "when there are more than three admin users in the organisation" do
      before do
        third_user.membership_for(organisation).update!(can_manage_team: true)
        third_user.membership_for(organisation).confirm!
        visit edit_membership_path(second_user.membership_for(organisation))
        click_on "Remove user from GovWifi admin"
      end

      it "asks for confirmation" do
        expect(page).to have_content("Are you sure you want to remove #{second_user.name}?")
      end

      it "displays a link to cancel" do
        expect(page).to have_link("Cancel")
      end

      it "redirects to the edit form when 'Cancel' is clicked" do
        click_on "Cancel"
        expect(page).to have_current_path(edit_membership_path(second_user.membership_for(organisation)))
      end

      it "hides the delete user link when already clicked" do
        expect(page).not_to have_content("Remove user from service")
      end

      it "deletes the membership" do
        expect { click_on "Yes, remove this team member" }.to change(Membership, :count).by(-1)
      end

      it "redirects to 'after user removed' team members page for analytics" do
        click_on "Yes, remove this team member"
        expect(page).to have_current_path("/memberships")
        expect(page).to have_content("Team member has been removed")
      end
    end
  end

  context "without correct permissions" do
    before do
      user.membership_for(organisation).update!(can_manage_team: false)
    end

    context "when visiting remove team member url directly" do
      it "does not show the page" do
        expect {
          visit edit_membership_path(second_user.membership_for(organisation), remove_team_member: true)
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
