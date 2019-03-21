describe UseCases::Administrator::ValidateLogSearchQuery do
  let(:email) { 'test@example.com' }
  let(:use_case) { described_class.new }

  context 'with valid search params' do
    context 'with valid username' do
      let(:valid_params) do
        [
          { username: 'ABCDE', ip: nil },
          { username: 'ABCDEF', ip: nil },
          { username: nil, ip: '1.2.3.4' }
        ]
      end

      it 'returns true' do
        valid_params.each do |valid_param|
          expect(use_case.execute(valid_param)).to eq(success: true)
        end
      end
    end
  end

  context 'with invalid search params' do
    context 'with invalid username and invalid ip' do
      let(:invalid_params) do
        [
          { username: nil, ip: nil },
          { username: nil, ip: '1' },
          { username: '', ip: '' },
          { username: 'A', ip: '' }
        ]
      end

      it 'returns false' do
        invalid_params.each do |invalid_param|
          expect(use_case.execute(invalid_param)).to eq(success: false)
        end
      end
    end
  end
end
