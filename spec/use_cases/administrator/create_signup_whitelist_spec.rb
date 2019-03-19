describe UseCases::Administrator::CreateSignupWhitelist do
  let(:result) { subject.execute(authorised_domains) }

  context 'when no domains' do
    let(:authorised_domains) { [] }

    it 'creates no whitelist' do
      expect(result).to eq('^$')
    end
  end

  context 'when one domain' do
    let(:authorised_domains) { %w(gov.uk) }

    it 'escapes the fullstops' do
      expect(result).to include('\.')
    end

    it 'creates a whitelist with one entry' do
      expect(result).to eq(SIGNUP_WHITELIST_PREFIX_MATCHER + '(gov\.uk)$')
    end
  end

  context 'when multiple domains' do
    let(:authorised_domains) { %w(gov.uk police.uk some.domain.org.uk) }

    it 'creates a whitelist with multiple entries' do
      expect(result).to eq(SIGNUP_WHITELIST_PREFIX_MATCHER + '(gov\.uk|police\.uk|some\.domain\.org\.uk)$')
    end
  end
end
