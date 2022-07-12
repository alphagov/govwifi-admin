describe "DELETE /authorised_email_domains/:id", type: :request do
  let!(:email_domain) { create(:authorised_email_domain, name: "some.domain.org.uk") }
  let(:regex_gateway) { instance_spy(Gateways::S3, write: nil) }
  let(:email_domains_gateway) { instance_spy(Gateways::S3) }

  before { allow(Gateways::S3).to receive(:new).and_return(regex_gateway, email_domains_gateway) }

  context "when the user is a super admin" do
    before do
      https!
      sign_in_user(create(:user, :super_admin, :with_organisation))
    end

    it "deletes the email domain" do
      expect {
        delete super_admin_allowlist_email_domain_path(email_domain)
      }.to change(AuthorisedEmailDomain, :count).by(-1)
    end

    it "publishes the new regex list of authorised domains to S3" do
      delete super_admin_allowlist_email_domain_path(email_domain)
      expect(regex_gateway).to have_received(:write)
    end

    it "publishes the new list of email domains to S3" do
      delete super_admin_allowlist_email_domain_path(email_domain)
      expect(email_domains_gateway).to have_received(:write)
    end
  end

  context "when the user is not super admin" do
    before do
      https!
      sign_in_user(create(:user))
    end

    it "does not delete the email domain" do
      expect {
        delete super_admin_allowlist_email_domain_path(email_domain)
      }.to change(AuthorisedEmailDomain, :count).by(0)
    end
  end
end
