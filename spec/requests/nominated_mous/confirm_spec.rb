describe "GET /nominated_mous/confirm", type: :request do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  before do
    https!
    sign_in_user(user)
  end

  it "renders the show options page" do
    get confirm_nominated_mous_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:confirm)
  end
end
