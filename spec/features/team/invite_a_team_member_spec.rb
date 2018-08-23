require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe "Invite a team member" do
  context "when logged out" do
    before do
      visit new_user_invitation_path
    end

    it_behaves_like 'not signed in'
  end

  context "when logged in" do
    let(:user) { create(:user, :confirmed) }
    before do
      sign_in_user user
      visit new_user_invitation_path
    end

    it "shows the invites page" do
      expect(page).to have_content("Send invitation")
    end

    context "with correct data" do
      before do
        fill_in "Email", with: "testing@gov.uk"
        click_on "Send an invitation"
      end

      it "sends an invitation link" do
      end
    end
  end
end
