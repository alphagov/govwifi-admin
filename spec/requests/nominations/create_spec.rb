describe "POST /nominations", type: :request do
  include EmailHelpers

  let(:user) { create(:user, :with_organisation) }
  let(:name) { "nomination_name" }
  let(:email) { "govwifi@gov.uk" }
  let(:token) { "12345" }

  subject(:perform) { post nomination_path, params: { nomination: { name:, email: } } }

  before do
    https!
    sign_in_user(user)
    allow(Services).to receive(:email_gateway).and_return(spy)
  end
  it "creates a new mou" do
    expect { perform }.to change(Nomination, :count).by(1)
  end

  it "destroys the old mou" do
    Nomination.create(name:, email:, token:, organisation: user.organisations.first)
    expect { perform }.to_not change(Nomination, :count)
  end

  it "sends an email to the nominated user" do
    perform
    it_sent_a_nomination_email_once
  end

  it "redirects to the what happens next path path" do
    perform
    expect(response).to redirect_to(what_happens_next_mous_path)
  end

  it "sets the right parameters in the Nomination object" do
    perform
    nomination = Nomination.find_by(token)
    expect(nomination).to_not be nil
    expect(nomination.name).to eq(name)
    expect(nomination.email).to eq(email)
    expect(nomination.organisation).to eq(user.organisations.first)
  end

  describe "the user did add an email for the nomination" do
    let(:email) { nil }
    it "re-renders the new nomination page" do
      perform
      expect(response).to render_template(:new)
    end
  end
end
