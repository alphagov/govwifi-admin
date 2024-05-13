describe "GET /mous/show_options", type: :request do
  let(:user) { create(:user, :with_organisation) }
  before do
    https!
    sign_in_user(user)
  end
  it "renders the show options page" do
    get show_options_mous_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:show_options)
  end
end
