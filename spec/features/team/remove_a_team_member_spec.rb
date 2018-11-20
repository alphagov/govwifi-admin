require 'features/support/sign_up_helpers'

describe "Remove a team member" do
  context "with the correct permissions" do
    let(:user) { create(:user, :confirmed) }
    let!(:another_user) { create(:user, :confirmed, organisation: user.organisation) }

    before do
      sign_in_user user
      visit edit_permission_path(user)
      click_on "Remove user from service"
    end

    it "shows an alert when removing a team member" do
      expect(page).to have_content("Are you sure you want to remove")
    end

    it 'does not have delete user link when already clicked' do
      expect(page).to_not have_content("Remove user from service")
    end

    it 'can delete a user' do
      expect { click_on "Yes, remove this team member" }.to change { User.count }.by(-1)
    end

    context "when you do not own the correct permissions to remove a team member" do
      let(:other_team_member) { create(:user, :confirmed, organisation: user.organisation) }
      before do
        visit remove_team_member_path(other_team_member)
      end

      it 'should not allow a user to remove a member when accessing the link directly' do
        expect(page).to_not have_content("Yes, remove this team member")
      end
    end
  end
end
