describe "DELETE /authorised_email_domains/:id", type: :request do
  let(:admin_user) { create(:user, super_admin: true) }
  let!(:authorised_email_domain) { create(:authorised_email_domain, name: 'some.domain.org.uk') }

  before do
    https!
    login_as(admin_user, scope: :user)
  end

  context "when the user is a super admin" do
    it "deletes the email domain" do
      expect {
        delete admin_authorised_email_domains_path(authorised_email_domain)
      }.to change { AuthorisedEmailDomain.count }.by(-1)
    end
  end
end
