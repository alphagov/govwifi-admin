require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'

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
        allow(SendInviteEmail).to \
          receive(:new).and_return(InviteUseCaseSpy.new)
        fill_in "Email", with: "testing@gov.uk"
      end

      after do
        ConfirmationUseCaseSpy.clear!
      end

      it "creates an unconfirmed user" do
        expect {
          click_on "Send an invitation"
        }.to change { User.count }.by(1)
        expect(User.last.confirmed?).to eq(false)
      end

      it "sends the invite email" do
        expect(InviteUseCaseSpy.invite_count).to eq(1)
      end
    end
  end
end
