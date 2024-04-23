require_relative "./certificate_helpers"

describe "GET /certificates", type: :request do
  include CertificateHelpers

  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }

  before :each do
    https!
    sign_in_user(user)
  end

  it "successfully renders the index template" do
    get certificates_path
    successfully_renders_template(:index)
  end
  it "redirects without permission" do
    remove_edit_location_permission
    get certificates_path
    redirects_with_error_message
  end
  it "redirects when the cba flag is disabled" do
    no_cba_enabled_flag
    get certificates_path
    redirects_with_error_message
  end
end
