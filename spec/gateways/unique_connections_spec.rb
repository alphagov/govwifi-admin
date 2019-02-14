describe Gateways::UniqueConnections do
  subject { described_class.new(ips: my_ips) }
  let(:my_ips) { ['127.0.0.1', '127.0.0.2', '127.0.0.3'] }

  let(:today) { Time.now.to_s }
  let(:yesterday) { (Time.now - 1.day).to_s }
  let(:two_days_ago) { (Time.now - 2.days).to_s }

  let(:username_1) { 'AAAAAA' }
  let(:username_2) { 'BBBBBB' }
  let(:username_3) { 'CCCCCC' }

  it 'will not count any unsuccessful connections' do
    Session.create(start: today, success: false, username: username_1, siteIP: '127.0.0.1')
    Session.create(start: today, success: false, username: username_2, siteIP: '127.0.0.2')
    Session.create(start: today, success: false, username: username_3, siteIP: '127.0.0.3')

    result = subject.unique_user_count
    expect(result).to eq(0)
  end

  context 'successful connections' do
    it 'counts only unique connections' do
      Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
      Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.2')
      Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.3')

      result = subject.unique_user_count
      expect(result).to eq(1)
    end

    context 'within a given time period' do
      it 'counts results within 24 hours' do
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: yesterday, success: true, username: username_2, siteIP: '127.0.0.2')
        Session.create(start: two_days_ago, success: true, username: username_3, siteIP: '127.0.0.3')

        result = subject.unique_user_count(date_range: 24.hours.ago)
        expect(result).to eq(1)
      end

      it 'counts results within 2 days' do
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: yesterday, success: true, username: username_2, siteIP: '127.0.0.2')
        Session.create(start: two_days_ago, success: true, username: username_3, siteIP: '127.0.0.3')

        result = subject.unique_user_count(date_range: 2.days.ago)
        expect(result).to eq(2)
      end
    end
  end
end
