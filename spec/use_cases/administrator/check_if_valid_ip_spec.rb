describe UseCases::Administrator::CheckIfValidIp do
  subject(:use_case) { described_class.new }

  let(:success_result) { use_case.execute(address)[:success] }
  let(:is_ipv6?) { use_case.execute(address)[:ipv6?] }

  context 'when invalid' do
    context 'with an invalid IP address' do
      let(:address) { "incorrectIP" }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with a private IP address' do
      let(:address) { "10.255.255.255" }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with an empty string' do
      let(:address) { '' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with nil' do
      let(:address) { nil }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with a trailing dot' do
      let(:address) { '172.16.254.1.' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with trailing whitespace' do
      let(:address) { '172.16.254.1 ' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with a mistyped IP address' do
      let(:address) { '192.618.0.1' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with a loopback IP address' do
      let(:address) { '127.0.0.1' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end
  end

  context 'when not an IPv4' do
    context 'with a valid subnet IPv4 address' do
      let(:address) { '192.168.1.15/24' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end
    end

    context 'with a valid IPv6 address' do
      let(:address) { '2001:db8:0:1234:0:567:8:1' }

      it 'returns false' do
        expect(success_result).to eq(false)
      end

      it 'recognises the address format' do
        expect(is_ipv6?).to eq(true)
      end
    end
  end

  context 'when valid' do
    context 'with a valid IPv4 address' do
      let(:address) { '141.0.149.130' }

      it 'returns true' do
        expect(success_result).to eq(true)
      end
    end
  end
end
