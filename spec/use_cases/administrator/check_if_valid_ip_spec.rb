describe CheckIfValidIp do
  subject { described_class.new }

  context 'invalid' do
    context 'with an invalid IP Address' do
      let(:address) { "incorrectIP" }

      it 'returns false' do
        result = subject.execute(address)
        expect(result).to eq(success: false)
      end
    end

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

    context 'with a trailing dot' do
      let(:address) { '172.16.254.1.' }

      it 'returns false' do
        result = subject.execute(address)
        expect(result).to eq(success: false)
      end
    end

    context 'with trailing whitespace' do
      let(:address) { '172.16.254.1 ' }

      it 'returns false' do
        result = subject.execute(address)
        expect(result).to eq(success: false)
      end
    end
  end

  context 'valid' do
    context 'with a valid IPv4 address' do
      let(:address) { '172.16.254.1' }

      it 'returns true' do
        result = subject.execute(address)
        expect(result).to eq(success: true)
      end
    end

    context 'with a valid suffixed IPv4 address' do
      let(:address) { '192.168.1.15/24' }

      it 'returns true' do
        result = subject.execute(address)
        expect(result).to eq(success: true)
      end
    end

    context 'with a valid IPv6 address' do
      let(:address) { '2001:db8:0:1234:0:567:8:1' }

      it 'returns true' do
        result = subject.execute(address)
        expect(result).to eq(success: true)
      end
    end
  end
end
