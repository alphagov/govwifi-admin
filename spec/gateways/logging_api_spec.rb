describe Gateways::LoggingApi do
  describe '#search' do
    subject { described_class.new }

    context "with correct data" do
      let(:username) { "AAAAAA" }
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
        endpoint = ENV['LOGGING_API_SEARCH_ENDPOINT'] + username
        stub_request(:get, endpoint)
          .with(headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host' => 'govwifi-logging-api.gov.uk',
              'User-Agent' => 'Ruby'
            })
          .to_return(status: 200, body: logs.to_json, headers: {})
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

      context "with an incorrect username" do
        context "with a username that is shorter than 6 characters" do
          it "returns an empty array" do
            expect(subject.search(username: "12")).to eq([])
          end
        end

        context "with a username that is longer than 6 characters" do
          it "returns an empty array" do
            expect(subject.search(username: "1234567")).to eq([])
          end
        end
      end
    end
  end
end
