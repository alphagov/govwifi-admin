describe Gateways::UniqueConnections do
  context 'unique user count' do
    subject { described_class.new(ips: my_ips).unique_user_count }

    let(:my_ips) { ['127.0.0.1', '127.0.0.2', '127.0.0.3'] }
    let(:today) { Time.now.to_s }
    let(:username_1) { 'AAAAAA' }
    let(:username_2) { 'BBBBBB' }

    context 'with one successful and one unsuccessful connection' do
      before do
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: today, success: false, username: username_2, siteIP: '127.0.0.2')
      end

      it { is_expected.to eq 1 }
    end

    context 'with three sessions for the same user' do
      before do
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.2')
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.3')
      end

      it { is_expected.to eq 1 }
    end

    context 'with two recent sessions and one older session' do
      let(:yesterday) { (Time.now - 1.day).to_s }
      let(:username_3) { 'CCCCCC' }

      before do
        Session.create(start: today, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: today, success: true, username: username_2, siteIP: '127.0.0.2')
        Session.create(start: yesterday, success: true, username: username_3, siteIP: '127.0.0.3')
      end

      it { is_expected.to eq 2 }
    end
  end
end
