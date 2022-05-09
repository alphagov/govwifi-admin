describe "POST /users/invitation", type: :request do
  let(:user) { create(:user, :with_2fa, organisations: [organisation]) }
  let(:organisation) { create(:organisation) }
  let(:email_gateway) { spy }

  before do
    allow(Services).to receive(:email_gateway).and_return(email_gateway)
    https!
    login_as(user, scope: :user)
  end

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
      expect(email_gateway).to have_received(:send_email)
        .with(include(template_id: GOV_NOTIFY_CONFIG["invite_email"]["template_id"])).once
    end

    it "ignores provided organisation_id" do
      user = User.find_by(email:)
      expect(user.organisations).to eq([organisation])
    end
  end
end
