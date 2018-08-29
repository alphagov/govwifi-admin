describe Gateways::Route53 do
  it '.list_health_checks' do
    expect(subject.list_health_checks.health_checks).to be_empty
  end

  it '.get_health_check_status' do
    expect(subject.get_health_check_status(health_check_id: 'abc').health_check_observations).to be_empty
  end
end
