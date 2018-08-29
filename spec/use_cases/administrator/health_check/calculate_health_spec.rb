class FakeHealthyRoute53Gateway
  def get_health_check_status(health_check_id:)
    client = Aws::Route53::Client.new(stub_responses: true)

    client.stub_responses(:get_health_check_status,
      health_check_observations:
        [
          {
            region: 'ap-southeast-2',
            ip_address: '39.239.222.111',
            status_report: {
              status: 'Success: HTTP Status Code 200, OK'
            }
          }, {
            region: 'ap-eu-west-1',
            ip_address: '27.111.39.33',
            status_report: {
              status: 'Success: HTTP Status Code 200, OK'
            }
          }
        ])

    client.get_health_check_status(health_check_id: health_check_id)
  end
end

class FakeUnHealthyRoute53Gateway
  def get_health_check_status(health_check_id:)
    client = Aws::Route53::Client.new(stub_responses: true)

    client.stub_responses(:get_health_check_status,
      health_check_observations:
        [
          {
            region: 'ap-southeast-2',
            ip_address: '39.239.222.111',
            status_report: {
              status: 'Failure: HTTP Status Code 500, Host Unreachable'
            }
          }, {
            region: 'ap-eu-west-1',
            ip_address: '27.111.39.33',
            status_report: {
              status: 'Success: HTTP Status Code 200, OK'
            }
          }
        ])

    client.get_health_check_status(health_check_id: health_check_id)
  end
end

class FakeEmptyHealthCheckIdsUseCase
  def execute
    []
  end
end

class FakeHealthCheckIdsUseCase
  def execute
    [
      { ip_address: '123.123.123.123', id: 'abc123' }
    ]
  end
end

describe UseCases::Administrator::HealthChecks::CalculateHealth do
  let(:aws_route53_gateway) { FakeHealthyRoute53Gateway.new }
  let(:health_checks_fetcher) { FakeHealthCheckIdsUseCase.new }

  let(:result) do
    described_class.new(
      route53_gateway: aws_route53_gateway,
      health_checks_fetcher: health_checks_fetcher
    ).execute
  end

  context 'Given checks are healthy' do
    it 'returns healthy if all health checkers are healthy' do
      expected_result = [{ ip: '123.123.123.123', status: :healthy }]

      expect(result).to eq(expected_result)
    end
  end

  context 'Given some checks have not passed' do
    let(:aws_route53_gateway) { FakeUnHealthyRoute53Gateway.new }

    it 'returns healthy if all health checkers are healthy' do
      expected_result = [
        { ip: '123.123.123.123', status: :unhealthy }
      ]

      expect(result).to eq(expected_result)
    end
  end

  context 'No health checks found' do
    let(:health_checks_fetcher) { FakeEmptyHealthCheckIdsUseCase.new }

    it 'returns an empty list if no health check ids are supplied' do
      expect(result).to be_empty
    end
  end


  it 'calls .execute on the gateway' do
    aws_route53_gateway = spy
    health_checks_fetcher = FakeHealthCheckIdsUseCase.new
    described_class.new(
      route53_gateway: aws_route53_gateway,
      health_checks_fetcher: health_checks_fetcher
    ).execute

    expect(aws_route53_gateway).to have_received(:get_health_check_status)
      .with(health_check_id: 'abc123')
      .once
  end
end
