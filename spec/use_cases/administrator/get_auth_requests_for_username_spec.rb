describe UseCases::Administrator::GetAuthRequestsForUsername do
  let(:authentication_logs_gateway) { Gateways::LoggingApi.new }
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

  subject { described_class.new(authentication_logs_gateway: authentication_logs_gateway) }

  before do
    allow(authentication_logs_gateway).to receive(:search)
      .with(username: username)
      .and_return(logs)
  end

  it "returns the logs" do
    result = subject.execute(username: username)
    expect(result).to eq(logs)
  end
end
