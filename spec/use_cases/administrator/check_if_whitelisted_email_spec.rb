describe UseCases::Administrator::CheckIfWhitelistedEmail do
  subject { described_class.new(gateway: s3_gateway) }

  let(:s3_gateway) { double(read: '^.*@(aaa\.uk)$') }

  context 'given a whitelisted email' do
    it 'accepts an address matching the regex' do
      result = subject.execute('someone@aaa.uk')
      expect(result).to eq(success: true)
    end

    it 'accepts an address matching the regex regardless of case' do
      result = subject.execute('SOMEONE@AAA.UK')
      expect(result).to eq(success: true)
    end
  end

  context 'given a non-whitelisted email' do
    it 'rejects an address not matching the regex' do
      result = subject.execute('someone@bbb.uk')
      expect(result).to eq(success: false)
    end
  end

  context 'given an invalid email' do
    it 'rejects an empty email address' do
      result = subject.execute('')
      expect(result).to eq(success: false)
    end

    it 'rejects a nil address' do
      result = subject.execute(nil)
      expect(result).to eq(success: false)
    end

    it 'respects subdomains' do
      result = subject.execute('someone@aaauk')
      expect(result).to eq(success: false)
    end
  end
end
