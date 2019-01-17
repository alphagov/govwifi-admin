describe UseCases::Administrator::GetUniqueUserRequests do
  let(:authentication_logs_gateway) { spy }

  subject do
    described_class.new(
      authentication_logs_gateway: authentication_logs_gateway,
    )
  end

  context 'count results' do
    context 'without a given time frame' do
      it 'calls the unique user count method on the gateway' do
        subject.execute

        expect(authentication_logs_gateway).to have_received(:unique_user_count)
          .with(date_range: nil)
      end
    end

    context 'within a given time frame' do
      let(:today) { Time.now.to_s }

      it 'calls the unique user count method on the gateway' do
        subject.execute(date_range: today)

        expect(authentication_logs_gateway).to have_received(:unique_user_count)
          .with(date_range: today)
      end
    end
  end
end
