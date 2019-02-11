describe UseCases::Administrator::GetRecentUniqueUserRequests do
  let(:authentication_logs_gateway) { spy }

  subject do
    described_class.new(
      authentication_logs_gateway: authentication_logs_gateway,
    )
  end

  it 'calls the unique user count method on the gateway' do
    subject.execute
    expect(authentication_logs_gateway).to have_received(:unique_user_count)
  end
end
