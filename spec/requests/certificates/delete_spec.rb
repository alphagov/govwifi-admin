require_relative "./certificate_helpers"

describe "GET /certificates/edit/:id", type: :request do
  include CertificateHelpers

  let(:organisation) { create(:organisation, :with_cba_enabled) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:certificate) { create(:certificate, organisation:) }
  before :each do
    https!
    sign_in_user(user)
  end

  it "deletes a certificate" do
    certificate
    expect { delete certificate_path(certificate) }.to change(Certificate, :count).from(1).to(0)
  end
  it "redirects to the index certificates page" do
    delete certificate_path(certificate)
    expect(response).to redirect_to certificates_path
  end
  it "redirects without edit location permission" do
    remove_edit_location_permission
    delete certificate_path(certificate)
    redirects_with_error_message
  end
  it "redirects if the user is not a member of the certificates organisation" do
    user_is_not_a_member_of_the_certificates_organisation
    delete certificate_path(certificate)
    redirects_with_error_message
  end
  it "redirects when the cba flag is disabled" do
    no_cba_enabled_flag
    get certificates_path
    redirects_with_error_message
  end
end
