describe "POST /nominated_mous", type: :request do
  include EmailHelpers

  let(:organisation) { create(:organisation) }
  let(:token) { "12345" }
  let(:name) { "myname" }
  let(:email_address) { "govwifi@gov.uk" }
  let(:job_role) { "software developer" }
  let(:signed) { "true" }
  subject(:perform) { post nominated_mous_path, params: { mou_form: { name:, email_address:, job_role:, signed:, token: } } }
  before do
    Nomination.create!(token: "12345", name:, email: email_address, organisation:)
    https!
  end
  describe "correct token and signed" do
    it "creates a new mou" do
      expect { perform }.to change(Mou, :count).by(1)
    end
    it "sends a thank you email" do
      perform
      it_sent_a_thank_you_for_signing_the_mou_email_once
    end
    it "redirects to the confirmation path" do
      perform
      expect(response).to redirect_to(confirm_nominated_mous_path(organisation_name: organisation.name))
    end
    it "sets the right parameters in the MOU object" do
      perform
      mou = Mou.find_by_name(name)
      expect(mou).to_not be nil
      expect(mou.email_address).to eq(email_address)
      expect(mou.job_role).to eq(job_role)
      expect(mou.organisation).to eq(organisation)
    end
  end
  describe "the user did not sign the mou" do
    let(:signed) { "false" }
    it "re-renders the new mou page" do
      perform
      expect(response).to render_template(:new)
    end
  end
  describe "wrong token" do
    let(:token) { "does_not_exist" }
    it "redirects to the root" do
      get new_nominated_mou_path, params: { token: }
      expect(response).to redirect_to(root_path)
    end
  end
end
