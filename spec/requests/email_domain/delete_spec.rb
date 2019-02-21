describe "DELETE /authorised_email_domains/:id", type: :request do
  let(:admin_user) { create(:user, super_admin: true) }
  let(:normal_user) { create(:user, super_admin: false) }
  let!(:email_domain_1) { create(:authorised_email_domain, name: 'some.domain.org.uk') }
  let!(:email_domain_2) { create(:authorised_email_domain, name: 'police.uk') }

  context "when the user is a super admin" do
    before do
      https!
      login_as(admin_user, scope: :user)
    end

    it "deletes the email domain" do
      expect {
        delete admin_authorised_email_domain_path(email_domain_1)
      }.to change { AuthorisedEmailDomain.count }.by(-1)
    end

    it 'publishes the authorised domains to S3' do
      expect_any_instance_of(Gateways::S3).to receive(:upload)
      delete admin_authorised_email_domain_path(email_domain_1)
    end
  end

  context "when the user is not super admin" do
    before do
      https!
      login_as(normal_user, scope: :user)
    end

    it "does not delete the email domain" do
      expect {
        delete admin_authorised_email_domain_path(email_domain_2)
      }.to change { AuthorisedEmailDomain.count }.by(0)
    end
  end
end
