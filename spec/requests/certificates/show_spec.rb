require_relative "./certificate_helpers"

describe "GET /certificate/:id", type: :request do
  include CertificateHelpers
  let(:certificate) { create(:certificate, organisation:) }
  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }

  before :each do
    https!
    sign_in_user(user)
  end
  it "successfully renders the show certificate template" do
    get certificate_path(certificate)
    successfully_renders_template(:show)
  end
  it "redirects without edit location permission" do
    remove_edit_location_permission
    get certificate_path(certificate)
    redirects_with_error_message
  end
  it "redirects if the user is not a member of the certificates organisation" do
    user_is_not_a_member_of_the_certificates_organisation
    get certificate_path(certificate)
    redirects_with_error_message
  end
  it "redirects when the cba flag is disabled" do
    no_cba_enabled_flag
    get certificate_path(certificate)
    redirects_with_error_message
  end
end
