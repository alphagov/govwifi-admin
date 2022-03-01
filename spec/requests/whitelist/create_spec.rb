describe "POST /admin/whitelist", type: :request do
  let(:user) { create(:user, :super_admin) }

  before do
    https!
    sign_in_user(user)
  end

  context "with valid params" do
    let(:regex_gateway) { instance_spy(Gateways::S3, write: nil) }
    let(:email_domains_gateway) { instance_spy(Gateways::S3) }
    let(:presenter) { instance_double(UseCases::Administrator::FormatEmailDomainsList) }
    let(:data) { instance_double(StringIO) }
    let(:valid_params) do
      {
        whitelist: {
          step: "sixth",
          organisation_name: "Made Tech",
          email_domain: "madetech.com",
        },
      }
    end

    before do
      allow(Gateways::S3).to receive(:new).and_return(regex_gateway, email_domains_gateway)
    end

    it "creates the related whitelist objects" do
      expect {
        post super_admin_whitelist_path, params: valid_params
      }.to change(CustomOrganisationName, :count).by(1)
      .and change(AuthorisedEmailDomain, :count).by(1)
    end

    it "publishes the email domain regex to S3" do
      post super_admin_whitelist_path, params: valid_params
      expect(regex_gateway).to have_received(:write)
    end

    it "publishes the email domain list to S3" do
      allow(UseCases::Administrator::FormatEmailDomainsList).to receive(:new).and_return(presenter)
      allow(presenter).to receive(:execute).and_return(data)
      post super_admin_whitelist_path, params: valid_params
      expect(email_domains_gateway).to have_received(:write).with(data:)
    end
  end

  context "with empty params" do
    let(:empty_params) do
      {
        whitelist: {
          step: "sixth",
          organisation_name: "",
          email_domain: "",
        },
      }
    end

    it "does not create the related whitelist objects" do
      expect {
        post super_admin_whitelist_path, params: empty_params
      }.to change(CustomOrganisationName, :count).by(0)
      .and change(AuthorisedEmailDomain, :count).by(0)
    end
  end

  context "with invalid params" do
    let(:organisation_name) { "Made Tech Ltd" }
    let(:email_domain) { "madetech.com" }
    let(:invalid_params) do
      {
        whitelist: {
          step: "sixth",
          organisation_name:,
          email_domain:,
        },
      }
    end

    before do
      AuthorisedEmailDomain.create!(name: email_domain)
      CustomOrganisationName.create!(name: organisation_name)
    end

    it "does not create the related whitelist objects" do
      expect {
        post super_admin_whitelist_path, params: invalid_params
      }.to change(CustomOrganisationName, :count).by(0)
      .and change(AuthorisedEmailDomain, :count).by(0)
    end
  end
end
