describe Organisation do
  context 'associations' do
    it { should have_many(:users) }
    it { should validate_uniqueness_of(:name) }
  end
end
