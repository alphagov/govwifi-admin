describe UseCases::Administrator::FormatEmailDomains do
  let(:result) { subject.execute(email_domains) }

  context 'with no email domains' do
    let(:email_domains) { [] }

    it 'creates no whitelist' do
      expect(result.read).to eq("--- []\n")
    end

    it 'returns an IO object' do
      expect(result).to be_an_instance_of(StringIO)
    end
  end

  context 'when one email domain is added' do
    let(:email_domains) { ["gov.uk"] }

    it 'creates a whitelist with one entry' do
      expect(result.read).to eq("---\n- gov.uk\n")
    end
  end

  context 'when two email domains are added' do
    let(:email_domains) { ["gov.uk", "made.eu"] }

    it 'creates a whitelist with two entries' do
      expect(result.read).to eq("---\n- gov.uk\n- made.eu\n")
    end
  end
end
