describe Gateways::Sessions do
  let(:today_date) { Date.today }
  let(:yesterday) { Date.today - 1 }
  let(:three_weeks_ago) { Date.today - 3.weeks }

  before do
    Session.delete_all
  end

  context 'recent logs' do
    before do
      Session.create(
        ap: '',
        building_identifier: '',
        mac: '',
        siteIP: '',
        start: today_date,
        success: true,
        username: 'BOBABC'
      )
    end

    it 'finds one recent session' do
      expected_result = [
        {
          ap: '',
          mac: '',
          site_ip: '',
          start: today_date,
          success: true,
          username: 'BOBABC'
        }
      ]

      expect(subject.search(username: 'BOBABC')).to eq(expected_result)
    end

    it 'finds multiple recent sessions' do
      Session.create(
        ap: '',
        building_identifier: '',
        mac: '',
        siteIP: '',
        start: yesterday,
        success: true,
        username: 'BOBABC'
      )

      expected_result = [
        {
          ap: '',
          mac: '',
          site_ip: '',
          start: today_date,
          success: true,
          username: 'BOBABC'
        }, {
          ap: '',
          mac: '',
          site_ip: '',
          start: yesterday,
          success: true,
          username: 'BOBABC'
        }
      ]

      expect(subject.search(username: 'BOBABC')).to eq(expected_result)
    end
  end

  context 'old log entries' do
    before do
      Session.create(
        ap: '',
        building_identifier: '',
        mac: '',
        siteIP: '',
        start: three_weeks_ago,
        success: true,
        username: 'FOOBAR'
      )
    end

    it 'excludes old sessions' do
      expect(subject.search(username: 'FOOBAR')).to be_empty
    end
  end
end
