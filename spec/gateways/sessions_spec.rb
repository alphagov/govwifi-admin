describe Gateways::Sessions do
  let(:my_ips) { ['127.0.0.1', '127.0.0.2', '127.0.0.3', '127.0.0.4', '127.0.0.5'] }
  subject { described_class.new(ips: my_ips) }
  let(:today_date) { Time.now.to_s }
  let(:yesterday) { (Time.now - 1.day).to_s }
  let(:two_days_ago) { (Time.now - 2.days).to_s }
  let(:three_weeks_ago) { (Time.now - 3.weeks).to_s }
  let(:username) { 'BOBABC' }

  context 'recent logs' do
    context 'log entries matching my IP addresses' do
      it 'finds one result' do
        Session.create(start: today_date, success: true, username: username, siteIP: '127.0.0.1')
        results = subject.search(username: username)

        expect(results.count).to eq(1)
      end

      it 'finds multiple results' do
        Session.create(start: yesterday, success: true, username: username, siteIP: '127.0.0.1')
        Session.create(start: today_date, success: true, username: username, siteIP: '127.0.0.1')

        expected_result = [
          {
            ap: nil,
            mac: nil,
            site_ip: '127.0.0.1',
            start: today_date,
            success: true,
            username: 'BOBABC'
          }, {
            ap: nil,
            mac: nil,
            site_ip: '127.0.0.1',
            start: yesterday,
            success: true,
            username: 'BOBABC'
          }
        ]

        expect(subject.search(username: 'BOBABC')).to eq(expected_result)
      end

      context 'results ordering' do
        it 'displays the newest logs first' do
          last_result = Session.create(start: two_days_ago, username: username, ap: 'ap3', siteIP: '127.0.0.1')
          first_result = Session.create(start: today_date, username: username, ap: 'ap1', siteIP: '127.0.0.1')
          middle_result = Session.create(start: yesterday, username: username, ap: 'ap2', siteIP: '127.0.0.1')

          result = subject.search(username: username)

          expect(result.first[:ap]).to eq(first_result.ap)
          expect(result.second[:ap]).to eq(middle_result.ap)
          expect(result.last[:ap]).to eq(last_result.ap)
        end
      end
    end

    context 'log entries not matching my IP addresses' do
      before do
        Session.create(start: today_date, username: username, siteIP: '7.7.7.7')
      end

      it 'finds no results' do
        result = subject.search(username: username)
        expect(result).to be_empty
      end

      it 'finds one results' do
        Session.create(start: today_date, username: username, siteIP: '127.0.0.1')

        result = subject.search(username: username)
        expect(result.count).to eq(1)
      end

      context 'Multiple IP addresses' do
        let(:my_ips) { ['1.1.1.1', '2.2.2.2'] }

        it 'only selects logs matching my IP addresses' do
          Session.create(start: today_date, username: username, siteIP: '1.1.1.1')
          Session.create(start: today_date, username: username, siteIP: '2.2.2.2')
          Session.create(start: today_date, username: username, siteIP: '3.3.3.3')

          result = subject.search(username: username)
          expect(result.count).to eq(2)
        end
      end
    end

    context 'Searching by IP' do
      let(:my_ips) { ['1.1.1.1', '2.2.2.2'] }

      before do
        ['1.1.1.1', '2.2.2.2', '3.3.3.3'].each do |ip|
          Session.create(start: today_date, username: username, siteIP: ip)
        end
      end

      it 'only selects logs matching my IP query' do
        result = subject.search(username: nil, ip: '1.1.1.1')
        expect(result.count).to eq(1)
      end

      it 'doesn\'t allow searching by another organisations IP' do
        result = subject.search(username: nil, ip: '3.3.3.3')
        expect(result).to be_empty
      end
    end
  end

  context 'old log entries' do
    before do
      Session.create(start: three_weeks_ago, success: true, username: 'FOOBAR', siteIP: '127.0.0.1')
    end

    it 'excludes results' do
      expect(subject.search(username: 'FOOBAR').count).to eq(0)
    end
  end

  context 'recent connections' do
    context 'within an organisation' do
      let(:username_1) { 'AAAAAA' }
      let(:username_2) { 'BBBBBB' }
      let(:username_3) { 'CCCCCC' }

      it 'counts the number of successful connections' do
        Session.create(start: today_date, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: today_date, success: false, username: username_1, siteIP: '127.0.0.2')
        Session.create(start: today_date, success: true, username: username_2, siteIP: '127.0.0.3')
        Session.create(start: today_date, success: false, username: username_2, siteIP: '127.0.0.4')
        Session.create(start: today_date, success: false, username: username_2, siteIP: '127.0.0.5')

        result = subject.count_distinct_users(ips: my_ips)
        expect(result).to eq(2)
      end

      it 'counts the number of successful connections' do
        Session.create(start: yesterday, success: true, username: username_1, siteIP: '127.0.0.1')
        Session.create(start: yesterday, success: true, username: username_2, siteIP: '127.0.0.2')
        Session.create(start: yesterday, success: true, username: username_3, siteIP: '127.0.0.3')
        Session.create(start: yesterday, success: false, username: username_2, siteIP: '127.0.0.4')

        result = subject.count_distinct_users(ips: my_ips)
        expect(result).to eq(3)
      end
    end
  end
end
