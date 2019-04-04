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
    let(:publish_instance) { instance_double(Facades::Ips::Publish) }

    before do
      allow(Facades::Ips::Publish).to receive(:new).and_return(publish_instance)
      allow(publish_instance).to receive(:execute)
    end

    it "deletes the IP" do
      expect {
        delete ip_path(ip)
      }.to change(Ip, :count).by(-1)
    end

    it "publishes the list of remaining IPs after a deletion" do
      delete ip_path(ip)
      expect(publish_instance).to have_received(:execute)
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
