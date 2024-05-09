describe "GET /nominated_mous/new", type: :request do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:token) { "12345" }
  let(:name) { "myname" }
  let(:email) { "govwifi@gov.uk" }
  before do
    Nomination.create!(token: "12345", name:, email:, organisation: )
    https!
    sign_in_user(user)
  end
  describe "correct token" do
    it "renders the show options page" do
      get new_nominated_mou_path, params: { token: }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end
  describe "incorrect token" do
    let(:token) { "does_not_exist" }
    it "redirects to the root" do
      get new_nominated_mou_path, params: { token: }
      expect(response).to redirect_to(root_path)
    end
  end
end
