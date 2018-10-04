describe Gateways::LoggingApi do
  describe '#search' do
    subject { described_class.new }

    context "with correct data" do
      let(:username) { "AAAAA" }
      let(:logs) do
        [
          {
            "ap" => "",
            "building_identifier" => "",
            "id" => 1,
            "mac" => "",
            "siteIP" => "",
            "start" => "2018-10-01 18:18:09 +0000",
            "stop" => nil,
            "success" => true,
            "username" => username
          },
          {
            "ap" => "",
            "building_identifier" => "",
            "id" => 1,
            "mac" => "",
            "siteIP" => "",
            "start" => "2018-10-01 18:18:09 +0000",
            "stop" => nil,
            "success" => true,
            "username" => username
          }
        ]
      end

      before do
        stub_request(:get, "http://govwifi-logging-api.com/authentication/events/search?username=#{username}").
          with(
           headers: {
         	  'Accept'=>'*/*',
         	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         	  'Host'=>'govwifi-logging-api.com',
         	  'User-Agent'=>'Ruby'
           }).
          to_return(status: 200, body: logs.to_json, headers: {})
      end

      it "returns the correct logs" do
        expect(subject.search(username: username)).to eq(logs)
      end
    end

    context "with incorrect data" do
      context "with an empty username" do
        it "returns an empty array" do
          expect(subject.search(username: "")).to eq([])
        end
      end

      context "when username is nil" do
        it "returns an empty array" do
          expect(subject.search(username: nil)).to eq([])
        end
      end
    end
  end
end
