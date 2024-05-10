describe "GET /nomination/new", type: :request do
  let(:user) { create(:user, :with_organisation) }
  before do
    https!
    sign_in_user(user)
  end

  it "renders the new nomination page" do
    get new_nomination_path
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:new)
  end
end
