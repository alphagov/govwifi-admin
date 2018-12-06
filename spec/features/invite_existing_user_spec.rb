require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe 'inviting a user', focus: true do
  let(:org_1) { create(:organisation, name: "Palm Trees Unlimted Company") }
  let(:org_2) { create(:organisation, name: "Palm Trees Unlimted 2.0 Company") }
  let(:user_1) { create(:user, organisation: org_1) }
  let(:invited_user) { create(:user, organisation: org_2) }

  before do
    sign_in_user user_1
    visit root_path
    click_on "Team members"
    click_on "Invite team member"
    fill_in "Email", with: invited_user.email
  end

  context 'when invited user has already created an account' do
    include_examples 'invite use case spy'
    include_examples 'notifications service'

    it "tells the user that the email has already been taken" do
      expect {
        click_on "Send invitation email"
      }.to change { User.count }.by(0)
      expect(InviteUseCaseSpy.invite_count).to eq(0)
      expect(page).to have_content("Email is already invited, or already registered with another organisation")
    end
  end
end
