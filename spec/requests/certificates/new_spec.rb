require_relative "./certificate_helpers"

describe "GET /certificates/new", type: :request do
  include CertificateHelpers

  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }

  before :each do
    https!
    sign_in_user(user)
  end

  it "successfully renders the new certificate template" do
    get new_certificate_path
    successfully_renders_template(:new)
  end
  it "redirects without edit location permission" do
    remove_edit_location_permission
    get new_certificate_path
    redirects_with_error_message
  end
  it "redirects when the cba flag is disabled" do
    no_cba_enabled_flag
    get new_certificate_path
    redirects_with_error_message
  end
end
