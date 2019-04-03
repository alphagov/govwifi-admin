describe LogsSearch do
  subject(:log_search) { described_class.new }

  context 'when searching by username' do
    before { log_search.filter = 'username' }

    context 'with blank term' do
      before { log_search.term = '' }

      it { is_expected.not_to be_valid }

      it 'explains it is blank' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term cannot be empty"
      end
    end

    context 'with 4 characters' do
      before { log_search.term = 'abcd' }

      it { is_expected.not_to be_valid }

      it 'explains the required length' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq 'Search term must be 5 or 6 characters'
      end
    end

    context 'with 5 characters' do
      before { log_search.term = 'abcde' }

      it { is_expected.to be_valid }
    end

    context 'with 6 characters' do
      before { log_search.term = 'abcdef' }

      it { is_expected.to be_valid }
    end

    context 'with 7 characters' do
      before { log_search.term = 'abcdefg' }

      it { is_expected.not_to be_valid }

      it 'explains the required length' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq 'Search term must be 5 or 6 characters'
      end
    end
  end

  context 'when searching by IP' do
    before { log_search.filter = 'ip' }

    context 'with blank term' do
      before { log_search.term = '' }

      it { is_expected.not_to be_valid }

      it 'explains it is blank' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term cannot be empty"
      end
    end

    context 'with an invalid IP' do
      before { log_search.term = 'badger' }

      it { is_expected.not_to be_valid }

      it 'explains it is invalid' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term must be a valid IP address"
      end
    end

    context 'with another invalid IP' do
      before { log_search.term = '10.x.20.30' }

      it { is_expected.not_to be_valid }

      it 'explains it is invalid' do
        log_search.valid?
        expect(log_search.errors.full_messages.first).to eq "Search term must be a valid IP address"
      end
    end

    context 'with a valid IP' do
      before { log_search.term = '11.22.33.44' }

      it { is_expected.to be_valid }
    end
  end
end
