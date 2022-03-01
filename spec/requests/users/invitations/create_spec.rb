require "support/invite_use_case"
require "support/notifications_service"

describe "POST /users/invitation", type: :request do
  let(:user) { create(:user, :with_2fa, organisations: [organisation]) }
  let(:organisation) { create(:organisation) }

  before do
    https!
    login_as(user, scope: :user)
  end

  include_context "when using the notifications service"
  include_context "when sending an invite email"

  context "with tampered organisation_id parameter" do
    let(:email) { "barry@gov.uk" }
    let(:other_organisation) { create(:organisation) }

    before do
      post user_invitation_path, params: { user: {
        email:,
        organisation_id: organisation.id,
      } }
    end

    it "invites a user" do
      expect(InviteUseCaseSpy.invite_count).to eq(1)
    end

    it "ignores provided organisation_id" do
      user = User.find_by(email:)
      expect(user.organisations).to eq([organisation])
    end
  end
end
