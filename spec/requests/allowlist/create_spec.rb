describe "POST /admin/allowlist", type: :request do
  let(:user) { create(:user, :super_admin) }
  let(:email_gateway) { EmailGatewaySpy.new }

  before do
    allow(Services).to receive(:email_gateway).and_return(email_gateway)
    https!
    sign_in_user(user)
  end

  context "with valid params" do
    let(:valid_params) do
      {
        allowlist: {
          step: Allowlist::SIXTH,
          organisation_name: "Made Tech",
          email_domain: "madetech.com",
        },
      }
    end

    it "creates the related allowlist objects" do
      expect {
        post super_admin_allowlist_path, params: valid_params
      }.to change(CustomOrganisationName, :count).by(1)
      .and change(AuthorisedEmailDomain, :count).by(1)
    end

    it "publishes the email domain regex to S3" do
      post super_admin_allowlist_path, params: valid_params
      expect(Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read).to include("madetech\\.com")
    end

    it "publishes the email domain list to S3" do
      post super_admin_allowlist_path, params: valid_params
      expect(Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).read).to eq(["madetech.com"].to_yaml)
    end
  end

  context "with empty params" do
    let(:empty_params) do
      {
        allowlist: {
          step: Allowlist::SIXTH,
          organisation_name: "",
          email_domain: "",
        },
      }
    end

    it "does not create the related allowlist objects" do
      expect {
        post super_admin_allowlist_path, params: empty_params
      }.to change(CustomOrganisationName, :count).by(0)
      .and change(AuthorisedEmailDomain, :count).by(0)
    end
  end

  context "with invalid params" do
    let(:organisation_name) { "Made Tech Ltd" }
    let(:email_domain) { "madetech.com" }
    let(:invalid_params) do
      {
        allowlist: {
          step: Allowlist::SIXTH,
          organisation_name:,
          email_domain:,
        },
      }
    end

    before do
      AuthorisedEmailDomain.create!(name: email_domain)
      CustomOrganisationName.create!(name: organisation_name)
    end

    it "does not create the related allowlist objects" do
      expect {
        post super_admin_allowlist_path, params: invalid_params
      }.to change(CustomOrganisationName, :count).by(0)
      .and change(AuthorisedEmailDomain, :count).by(0)
    end
  end
end
