class FakeHealthyRoute53Gateway
  def get_health_check_status(health_check_id:)
    client = Aws::Route53::Client.new(stub_responses: true)

    client.stub_responses(:get_health_check_status,
                          health_check_observations:
                            [
                              {
                                region: "ap-southeast-2",
                                ip_address: "39.239.222.111",
                                status_report: {
                                  status: "Success: HTTP Status Code 200, OK",
                                },
                              },
                              {
                                region: "ap-eu-west-1",
                                ip_address: "27.111.39.33",
                                status_report: {
                                  status: "Success: HTTP Status Code 200, OK",
                                },
                              },
                            ])

    client.get_health_check_status(health_check_id:)
  end

  def list_health_checks
    client = Aws::Route53::Client.new(
      stub_responses: {
        list_health_checks: {
          max_items: 10,
          marker: "PageMarker",
          is_truncated: false,
          health_checks: [
            {
              caller_reference: "AdminMonitoring",
              id: "abc123",
              health_check_version: 1,
              health_check_config: {
                ip_address: "111.111.111.111",
                measure_latency: false,
                type: "HTTP",
              },
            },
            {
              caller_reference: "AdminMonitoring",
              id: "xyz789",
              health_check_version: 1,
              health_check_config: {
                ip_address: "222.222.222.222",
                measure_latency: false,
                type: "HTTP",
              },
            },
          ],
        },
      },
    )

    client.list_health_checks
  end
end

class FakeUnHealthyRoute53Gateway
  def get_health_check_status(health_check_id:)
    client = Aws::Route53::Client.new(stub_responses: true)

    client.stub_responses(:get_health_check_status,
                          health_check_observations:
                            [
                              {
                                region: "ap-southeast-2",
                                ip_address: "39.239.222.111",
                                status_report: {
                                  status: "Failure: HTTP Status Code 500, Host Unreachable",
                                },
                              },
                            ])

    client.get_health_check_status(health_check_id:)
  end

  def list_health_checks
    client = Aws::Route53::Client.new(
      stub_responses: {
        list_health_checks: {
          max_items: 10,
          marker: "PageMarker",
          is_truncated: false,
          health_checks: [
            {
              caller_reference: "AdminMonitoring",
              id: "latency123",
              health_check_version: 1,
              health_check_config: {
                ip_address: "123.123.123.123",
                measure_latency: false,
                type: "HTTP",
              },
            },
          ],
        },
      },
    )

    client.list_health_checks
  end
end

describe UseCases::Administrator::HealthChecks::CalculateHealth do
  let(:aws_route53_gateway) { FakeHealthyRoute53Gateway.new }

  let(:result) do
    described_class.new(route53_gateway: aws_route53_gateway).execute(ips:)
  end

  context "when health checkers are healthy" do
    let(:ips) { ["111.111.111.111", "222.222.222.222"] }

    it "returns operational if all health checkers are healthy" do
      expected_result = [
        { ip_address: "111.111.111.111", status: :operational },
        { ip_address: "222.222.222.222", status: :operational },
      ]

      expect(result).to eq(expected_result)
    end
  end

  context "when some checkers are unhealthy" do
    let(:aws_route53_gateway) { FakeUnHealthyRoute53Gateway.new }
    let(:ips) { ["123.123.123.123"] }

    it "returns an offline status" do
      expected_result = [{ ip_address: "123.123.123.123", status: :offline }]

      expect(result).to eq(expected_result)
    end
  end

  context "when no health checks found" do
    let(:ips) { [] }

    it "finds no health checks" do
      expect(result).to be_empty
    end
  end

  it "calls .get_health_check_status on the gateway" do
    aws_route53_gateway = spy
    described_class.new(route53_gateway: aws_route53_gateway).execute(ips: ["111.111.111.111"])

    expect(aws_route53_gateway).to have_received(:get_health_check_status).once
  end
end
