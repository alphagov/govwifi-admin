describe UseCases::Administrator::FormatOrganisationNames do
  let(:result) { subject.execute(organisation_names) }

  context 'when no organisation names' do
    let(:organisation_names) { [] }

    it 'creates no whitelist' do
      expect(result).to eq('empty')
    end
  end

  context 'when one organisation name is added' do
    let(:organisation_names) { %w(Government Digital Services) }

    it 'creates a whitelist with one entry' do
      expect(result).to eq('- Government Digital Services')
    end
  end
end
