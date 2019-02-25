describe UseCases::Administrator::CreateSignupWhitelist do
  let(:result) { subject.execute(authorised_domains) }

  context 'given no domains' do
    let(:authorised_domains) { [] }

    it 'creates no whitelist' do
      expect(result).to eq('^$')
    end
  end

  context 'given one domain' do
    let(:authorised_domains) { %w(gov.uk) }

    it 'escapes the fullstops' do
      expect(result).to include('\.')
    end

    it 'creates a whitelist with one entry' do
      expect(result).to eq('^.*@([a-zA-Z0-9.-]+)?(gov\.uk)$')
    end
  end

  context 'given multiple domains' do
    let(:authorised_domains) { %w(gov.uk police.uk some.domain.org.uk) }

    it 'creates a whitelist with multiple entries' do
      expect(result).to eq('^.*@([a-zA-Z0-9.-]+)?(gov\.uk|police\.uk|some\.domain\.org\.uk)$')
    end
  end
end
