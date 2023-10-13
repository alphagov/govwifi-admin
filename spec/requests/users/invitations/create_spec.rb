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

  context "when the user already exists and therefore is invalid" do
    before do
      post user_invitation_path, params: {
        user: {
          email: user.email,
          organisation_id: organisation.id,
          source: "invite_admin",
        },
      }
    end

    it "renders the 'invite_second_admin' template" do
      expect(response).to render_template("invite_second_admin")
    end

    it "does not create a new user" do
      expect { user.reload }.to_not change(User, :count)
    end

    it "does not send an invitation email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "returns a 200 OK status" do
      expect(response).to have_http_status(:ok)
    end
  end
end
