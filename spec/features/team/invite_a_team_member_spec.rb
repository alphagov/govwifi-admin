require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

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
      include_examples 'invite use case spy'
      include_examples 'notifications service'
      let(:invited_user_email) { "testing@gov.uk" }
      let(:invited_user) { User.find_by(email: invited_user_email) }

      before do
        fill_in "Email", with: invited_user_email
      end

      it "creates an unconfirmed user" do
        expect {
          click_on "Send an invitation"
        }.to change { User.count }.by(1)
        expect(InviteUseCaseSpy.invite_count).to eq(1)
        expect(invited_user.confirmed?).to eq(false)
        expect(page).to have_content("Home")
      end
    end
  end
end
