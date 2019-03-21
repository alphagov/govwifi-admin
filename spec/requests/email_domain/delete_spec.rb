describe "DELETE /authorised_email_domains/:id", type: :request do
  let!(:email_domain) { create(:authorised_email_domain, name: 'some.domain.org.uk') }

  context "when the user is a super admin" do
    before do
      https!
      sign_in_user(create(:user, super_admin: true))
    end

    it "deletes the email domain" do
      expect {
        delete admin_authorised_email_domain_path(email_domain)
      }.to change(AuthorisedEmailDomain, :count).by(-1)
    end

    it 'publishes the authorised domains to S3' do
      expect_any_instance_of(Gateways::S3).to receive(:write)
      delete admin_authorised_email_domain_path(email_domain)
    end
  end

  context "when the user is not super admin" do
    before do
      https!
      sign_in_user(create(:user, super_admin: false))
    end

    it "does not delete the email domain" do
      expect {
        delete admin_authorised_email_domain_path(email_domain)
      }.to change(AuthorisedEmailDomain, :count).by(0)
    end
  end
end
