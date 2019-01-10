describe UseCases::Administrator::ValidateLogSearchQuery do
  let(:email) { 'test@example.com' }

  context 'Valid search params' do
    context 'valid username' do
      it 'returns true' do
        valid_params = [
          { username: 'ABCDE', ip: nil },
          { username: 'ABCDEF', ip: nil },
          { username: nil, ip: '1.2.3.4' }
        ]

        valid_params.each do |valid_param|
          expect(subject.execute(valid_param)).to eq(success: true)
        end
      end
    end
  end

  context 'Invalid search params' do
    context 'invalid username and invalid ip' do
      it 'returns false' do
        invalid_params = [
          { username: nil, ip: nil },
          { username: nil, ip: '1' },
          { username: '', ip: '' },
          { username: 'A', ip: '' }
        ]

        invalid_params.each do |invalid_param|
          expect(subject.execute(invalid_param)).to eq(success: false)
        end
      end
    end
  end
end
