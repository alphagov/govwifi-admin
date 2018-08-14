describe CheckIfWhitelistedEmail do
  subject { described_class.new }

  context 'with a regex in the environment variable' do
    before do
      ENV['AUTHORISED_EMAIL_DOMAINS_REGEX'] = 'someone@a+\.uk'
    end

    it 'rejects an empty email address' do
      result = subject.execute('')
      expect(result).to eq(success: false)
    end

    it 'rejects a nil address' do
      result = subject.execute(nil)
      expect(result).to eq(success: false)
    end

    it 'accepts an address matching the regex' do
      result = subject.execute('someone@aaa.uk')
      expect(result).to eq(success: true)
    end

    it 'rejects an address not matching the regex' do
      result = subject.execute('someone@bbb.uk')
      expect(result).to eq(success: false)
    end

    it 'accepts an address matching the regex regardless of case' do
      result = subject.execute('SOMEONE@AAA.UK')
      expect(result).to eq(success: true)
    end
  end

  context 'with no regex in the environment variable' do
    before do
      ENV.delete('AUTHORISED_EMAIL_DOMAINS_REGEX')
    end

    it 'blows up' do
      expect { subject.execute('any string') }
        .to raise_error(IndexError)
    end
  end
end
