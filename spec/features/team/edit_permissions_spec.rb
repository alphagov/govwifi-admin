describe "Edit user permissions", type: :feature do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:invited_user_other_org) { User.find_by(email: "invited_other_org@gov.uk") }
  let(:invited_user_same_org) { User.find_by(email: "invited_same_org@gov.uk") }

  before do
    create(:user, :with_organisation, email: "invited_other_org@gov.uk")
    create(:user, email: "invited_same_org@gov.uk", organisations: [organisation])
    sign_in_user user
  end

  context "without the .can_manage_team permission" do
    before do
      user.membership_for(organisation).update!(can_manage_team: false)
    end

    it "does not show the edit team member link" do
      visit memberships_path
      expect(page).not_to have_link("Edit permissions")
    end

    it "prevents visiting the edit permissions page directly" do
      membership = invited_user_same_org.membership_for(organisation)
      expect {
        visit edit_membership_path(membership)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  context "with the .can_manage_team permission" do
    context "when the user belongs to my organisation" do
      before do
        visit memberships_path
        click_link "Edit permissions"
        choose "View only"
        click_on "Save"
      end

      it "correctly sets the manage team permissions" do
        expect(invited_user_same_org.can_manage_team?(organisation)).to eq(false)
      end

      it "correctly sets the manage locations permissions" do
        expect(invited_user_same_org.can_manage_locations?(organisation)).to eq(false)
      end

      it "sets the correct success message" do
        expect(page).to have_content("Permissions updated")
      end

      it 'redirects to "after permission updated" team members page for analytics' do
        expect(page).to have_current_path("/memberships")
      end
    end

    context "when the user does not belong to my organisation" do
      it "restricts editing to only users in my organisation" do
        membership = invited_user_other_org.memberships.first
        expect {
          visit edit_membership_path(membership)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
