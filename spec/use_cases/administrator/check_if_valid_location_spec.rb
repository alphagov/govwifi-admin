describe UseCases::Administrator::CheckIfValidLocationAddress do
  subject { described_class.new }

  context 'invalid' do
    context 'with an empty string' do
      let(:address) { '' }

      it 'returns false' do
        result = subject.execute(address)
        expect(result).to eq(success: false)
      end
    end

    context 'with nil' do
      let(:address) { nil }

      it 'returns false' do
        result = subject.execute(address)
        expect(result).to eq(success: false)
      end
    end
  end

  context 'valid' do
    context 'with a valid location address' do
      let(:address) { 'London' }

      it 'returns true' do
        result = subject.execute(address)
        expect(result).to eq(success: true)
      end
    end
  end
end
