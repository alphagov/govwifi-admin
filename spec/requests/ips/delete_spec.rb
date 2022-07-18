describe "DELETE /ips/:id", type: :request do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let(:location) { create(:location, organisation: user.organisations.first) }
  let!(:ip) { create(:ip, location:) }

  before do
    https!
    login_as(user, scope: :user)
    skip_two_factor_authentication
    stub_request(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/")
    stub_request(:put, /s3.eu-west-2/)
  end

  context "when the user owns the IP" do
    let(:publish_ip) { instance_spy(Facades::Ips::Publish, execute: nil) }

    it "deletes the IP" do
      expect {
        delete ip_path(ip)
      }.to change(Ip, :count).by(-1)
    end

    it "publishes the list of remaining IPs after a deletion" do
      Gateways::S3.new(**Gateways::S3::RADIUS_IPS_ALLOW_LIST).write("Something")
      Gateways::S3.new(**Gateways::S3::LOCATION_IPS).write("Something")
      delete ip_path(ip)
      expect(Gateways::S3.new(**Gateways::S3::RADIUS_IPS_ALLOW_LIST).read).to eq("")
      expect(Gateways::S3.new(**Gateways::S3::LOCATION_IPS).read).to eq("[]")
    end
  end

  context "when the user does not own the IP" do
    let!(:other_ip) { create(:ip, location: create(:location)) }

    it "does not delete the IP" do
      expect {
        delete ip_path(other_ip)
      }.to change(Ip, :count).by(0)
    end
  end
end
