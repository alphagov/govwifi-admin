describe LogsSearch do
  context 'searching by username' do
    before { subject.filter = 'username' }

    context 'with blank term' do
      before { subject.term = '' }

      it { is_expected.to_not be_valid }

      it 'explains it is blank' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq "Search term cannot be empty"
      end
    end

    context 'with 4 characters' do
      before { subject.term = 'abcd' }

      it { is_expected.to_not be_valid }

      it 'explains the required length' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq 'Search term must be 5 or 6 characters'
      end
    end

    context 'with 5 characters' do
      before { subject.term = 'abcde' }

      it { is_expected.to be_valid }
    end

    context 'with 6 characters' do
      before { subject.term = 'abcdef' }

      it { is_expected.to be_valid }
    end

    context 'with 7 characters' do
      before { subject.term = 'abcdefg' }

      it { is_expected.to_not be_valid }

      it 'explains the required length' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq 'Search term must be 5 or 6 characters'
      end
    end
  end

  context 'searching by IP' do
    before { subject.filter = 'ip' }

    context 'with blank term' do
      before { subject.term = '' }

      it { is_expected.to_not be_valid }

      it 'explains it is blank' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq "Search term cannot be empty"
      end
    end

    context 'with an invalid IP' do
      before { subject.term = 'badger' }

      it { is_expected.to_not be_valid }

      it 'explains it is invalid' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq "Search term must be a valid IP address"
      end
    end

    context 'with another invalid IP' do
      before { subject.term = '10.x.20.30' }

      it { is_expected.to_not be_valid }

      it 'explains it is invalid' do
        subject.valid?
        expect(subject.errors.full_messages.first).to eq "Search term must be a valid IP address"
      end
    end

    context 'with a valid IP' do
      before { subject.term = '11.22.33.44' }

      it { is_expected.to be_valid }
    end
  end
end
