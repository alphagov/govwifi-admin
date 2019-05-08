describe UseCases::Administrator::FormatOrganisationNames do
  let(:result) { subject.execute(organisation_names) }

  context 'when no organisation names' do
    let(:organisation_names) { [] }

    it 'creates no whitelist' do
      expect(result).to eq('')
    end
  end

  context 'when one organisation name is added' do
    let(:organisation_names) { ["Government Digital Services"] }

    it 'creates a whitelist with one entry' do
      expect(result).to eq('- Government Digital Services')
    end
  end

  context 'when two organisations name are added' do
    let(:organisation_names) { ["Government Digital Services", "Made Tech"] }

    it 'creates a whitelist with two entries' do
      expect(result).to eq('- Government Digital Services\n- Made Tech')
    end
  end
end
