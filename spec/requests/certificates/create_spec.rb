require_relative "./certificate_helpers"

describe "POST /certificates", type: :request do
  include CertificateHelpers

  let(:certificate_content) { StringIO.new(CertificateHelper.new.root_ca.to_pem) }
  let(:certificate_file) { Rack::Test::UploadedFile.new(certificate_content, original_filename: "certificate.pem") }
  let(:certificate) { Certificate.find_by_name("test") }

  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }
  before :each do
    https!
    sign_in_user(user)
  end

  def post_certificate
    post certificates_path, params: { certificate_form: { file: certificate_file, name: "mycert" } }
  end

  context "valid certificate" do
    it "successfully creates a certificate" do
      expect {
        post_certificate
      }.to change(Certificate, :count).by(1)
    end
    it "redirects to the certificates index page" do
      post_certificate
      expect(response).to redirect_to certificates_path
      expect(flash[:notice]).to match(/New Certificate Added/)
    end
    it "redirects without edit location permission" do
      remove_edit_location_permission
      post_certificate
      redirects_with_error_message
    end
    it "redirects when the cba flag is disabled" do
      no_cba_enabled_flag
      get certificates_path
      redirects_with_error_message
    end
  end
  context "invalid certificate" do
    let(:certificate_content) { StringIO.new("invalid certificate") }

    it "does not create a certificate" do
      expect {
        post_certificate
      }.to_not change(Certificate, :count)
    end
    it "re-renders the new page" do
      post_certificate
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
