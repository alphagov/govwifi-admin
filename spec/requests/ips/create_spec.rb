describe "POST /ips", type: :request do
  let(:user) { create(:user, :with_organisation) }
  let(:location) { create(:location, organisation: user.organisations.first) }
  let(:ip_address) { "10.0.0.1" }

  before do
    login_as(user, scope: :user)
    Rails.application.config.force_ssl = false
    Rails.application.config.s3_aws_config = { access_key_id: "1234", secret_access_key: "abc" }

    stub_request(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/")
    .to_return(status: 200, body: "", headers: {})

    stub_request(:put, "https://s3.eu-west-2.amazonaws.com/StubBucket/StubKey")
    .with(body: "[{\"ip\":\"#{ip_address}\",\"location_id\":#{location.id}}]")
    .to_return(status: 200, body: "", headers: {})
  end

  it "publishes IP to s3 for performance platform" do
    post ips_path, params: { ip: { address: ip_address } }
  end
end
