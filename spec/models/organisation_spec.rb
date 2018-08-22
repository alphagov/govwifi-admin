describe Organisation do
  context 'associations' do
    it { should have_many(:users) }
  end
end
