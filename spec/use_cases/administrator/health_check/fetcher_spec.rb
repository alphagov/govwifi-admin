
class FakeRoute53Gateway
  def list_health_checks
    client = Aws::Route53::Client.new(
      stub_responses: {
        list_health_checks: {
          max_items: 10,
          marker: 'PageMarker',
          is_truncated: false,
          health_checks: [
            {
              caller_reference: 'AdminMonitoring',
              id: 'abc123',
              health_check_version: 1,
              health_check_config: {
                ip_address: '52.91.79.12',
                measure_latency: false,
                type: 'HTTP',
              }
            }, {
              caller_reference: 'AdminMonitoring',
              id: 'xyz789',
              health_check_version: 1,
              health_check_config: {
                ip_address: '53.54.89.98',
                measure_latency: false,
                type: 'HTTP',
              }
            }, {
              caller_reference: 'AdminMonitoring',
              id: 'zzzyyy',
              health_check_version: 1,
              health_check_config: {
                ip_address: '111.111.111.111',
                measure_latency: false,
                type: 'HTTP',
              }
            }, {
              caller_reference: 'AdminMonitoring',
              id: 'latency123',
              health_check_version: 1,
              health_check_config: {
                ip_address: '777.777.777.777',
                measure_latency: true,
                type: 'HTTP',
              }
            }
          ]
        }
      }
    )

    client.list_health_checks
  end
end

describe UseCases::Administrator::HealthChecks::Fetcher do
  let(:result) { described_class.new(route53_gateway: aws_route53_gateway, ips: ips).execute }
  let(:aws_route53_gateway) { FakeRoute53Gateway.new }

  it 'calls .list_health_checks on the gateway' do
    aws_route53_gateway = spy
    described_class.new(route53_gateway: aws_route53_gateway, ips: []).execute
    expect(aws_route53_gateway).to have_received(:list_health_checks)
  end

  context 'given a list of empty IP addresses' do
    let(:ips) { [] }

    it 'finds no results' do
      expect(result).to be_empty
    end
  end

  context 'Given IP addresses' do
    context 'Given 1 IP address' do
      let(:ips) { ['52.91.79.12'] }

      it 'finds one health check id' do
        expect(result).to eq(
          [
            { ip_address: '52.91.79.12', id: 'abc123' }
          ]
        )
      end
    end

    context 'Given multiple IP addresses' do
      let(:ips) { ['52.91.79.12', '53.54.89.98'] }

      it 'finds multiple health check ids' do
        expect(result).to eq([
          { ip_address: '52.91.79.12', id: 'abc123' },
          { ip_address: '53.54.89.98', id: 'xyz789' }
        ])
      end
    end

    context 'Given the IP of a latency health check' do
      let(:ips) { ['777.777.777.777'] }

      it 'returns no health check ids' do
        expect(result).to be_empty
      end
    end
  end
end
