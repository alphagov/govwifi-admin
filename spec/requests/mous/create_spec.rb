describe "POST /mous", type: :request do
  let(:user) { create(:user, :with_organisation) }
  let(:name) { "mou_name" }
  let(:email_address) { "govwifi@gov.uk" }
  let(:job_role) { "software developer" }
  let(:signed) { "true" }
  subject(:perform) { post mous_path, params: { mou_form: { name:, email_address:, job_role:, signed: } } }
  before do
    https!
    sign_in_user(user)
    allow(AuthenticationMailer).to receive(:thank_you_for_signing_the_mou).and_return(spy)
  end
  it "creates a new mou" do
    expect { perform }.to change(Mou, :count).by(1)
  end
  it "sends a thank you email" do
    perform
    expect(AuthenticationMailer).to have_received(:thank_you_for_signing_the_mou)
  end
  it "redirects to the settings path" do
    perform
    expect(response).to redirect_to(settings_path)
  end
  it "sets the right parameters in the MOU object" do
    perform
    mou = Mou.find_by_name(name)
    expect(mou).to_not be nil
    expect(mou.email_address).to eq(email_address)
    expect(mou.job_role).to eq(job_role)
    expect(mou.organisation).to eq(user.organisations.first)
    expect(mou.version).to eq(Mou.latest_version)
  end
  describe "the user did not sign the mou" do
    let(:signed) { "false" }
    it "re-renders the new mou page" do
      perform
      expect(response).to render_template(:new)
    end
  end
end
