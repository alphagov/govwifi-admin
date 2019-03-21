describe "DELETE /ips/:id", type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, organisation: user.organisation) }
  let!(:ip) { create(:ip, location: location) }

  before do
    https!
    login_as(user, scope: :user)
    stub_request(:get, 'http://169.254.169.254/latest/meta-data/iam/security-credentials/')
    stub_request(:put, /s3.eu-west-2/)
  end

  context "when the user owns the IP" do
    it "deletes the IP" do
      expect {
        delete ip_path(ip)
      }.to change(Ip, :count).by(-1)
    end

    it "Publishes the new list of IPs" do
      expect_any_instance_of(Facades::Ips::Publish).to receive(:execute)
      delete ip_path(ip)
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
