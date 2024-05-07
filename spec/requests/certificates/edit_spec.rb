describe "GET /certificates/edit/:id", type: :request do
  let(:certificate) { create(:certificate, organisation:) }

  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }
  subject(:perform) { get edit_certificate_path(certificate) }

  before :each do
    https!
    sign_in_user(user)
  end

  include_examples "cba flag and location permissions"
  include_examples "user is not a member of the certificate's organisation"

  it "successfully renders the edit certificate template" do
    perform
    expect(response).to have_http_status(:success)
    expect(response).to render_template(:edit)
  end
end
