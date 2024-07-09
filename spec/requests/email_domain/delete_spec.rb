describe "DELETE /authorised_email_domains/:id", type: :request do
  let!(:email_domain) { create(:authorised_email_domain, name: "some.domain.org.uk") }

  let(:notify_gateway) { EmailGatewaySpy.new }
  before do
    allow(Services).to receive(:notify_gateway).and_return(notify_gateway)
    Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).write("old regexp")
    Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).write("old allowlist")
  end

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
      expect {
        delete super_admin_allowlist_email_domain_path(email_domain)
      }.to change {
        Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read
      }.from("old regexp").to("^$")
    end

    it "publishes the new list of email domains to S3" do
      expect {
        delete super_admin_allowlist_email_domain_path(email_domain)
      }.to change {
        Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).read
      }.from("old allowlist").to([].to_yaml)
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
