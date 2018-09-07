describe Organisation do
  context 'associations' do
    it { should have_many(:users) }
    it { should have_many(:locations) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "#save" do
    subject { build(:organisation) }
    before do
      subject.save
    end

    it 'sets the radius_secret_key' do
      expect(subject.radius_secret_key).to be_present
    end
  end
end
