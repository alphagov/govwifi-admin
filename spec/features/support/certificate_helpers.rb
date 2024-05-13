RSpec.shared_examples "cba flag and location permissions" do
  it "redirects without edit location permission" do
    user.membership_for(organisation).update!(permission_level: "view_only")
    perform
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to match(/not allowed/)
  end
  it "redirects without the organisation having the cba flag enabled" do
    organisation.update!(cba_enabled: false)
    perform
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to match(/not allowed/)
  end
end

RSpec.shared_examples "user is not a member of the certificate's organisation" do
  it "redirects if the user is not a member of the certificate's organisation" do
    certificate.update!(organisation: create(:organisation, :with_cba_enabled))
    perform
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to match(/not allowed/)
  end
end
