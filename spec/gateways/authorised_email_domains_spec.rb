describe Gateways::AuthorisedEmailDomains do
  let(:result) do
    [
      'gov.uk',
      'eukri.gsi.com'
    ]
  end

  before do
    create(:authorised_email_domain, name: 'gov.uk')
    create(:authorised_email_domain, name: 'eukri.gsi.com')
  end

  it 'fetches the locations_ips' do
    expect(subject.fetch_domains).to eq(result)
  end
end
