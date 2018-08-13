describe CheckIfWhitelistedEmail do
  subject { described_class.new }

  it 'rejects an empty email address' do
    result = subject.execute('')
    expect(result).to eq({ success: false })
  end

  it 'approves an address from the gov.uk domain' do
    result = subject.execute('someone@gov.uk')
    expect(result).to eq({ success: true })
  end

  it 'approves an address from a gov.uk subdomain' do
    result = subject.execute('someone@other.gov.uk')
    expect(result).to eq({ success: true })
  end

  it 'rejects an address not from a gov.uk domain' do
    result = subject.execute('someone@notgov.uk')
    expect(result).to eq({ success: false })
  end

  it 'rejects an address not from a gov.uk subdomain' do
    result = subject.execute('someone@other.notgov.uk')
    expect(result).to eq({ success: false })
  end

  it 'rejects an address with gov in the local-part' do
    result = subject.execute('fake.gov.uk@unrelateddomain.com')
    expect(result).to eq({ success: false })
  end
end
