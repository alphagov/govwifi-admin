describe Organisation do
  context 'associations' do
    it { should have_many(:users) }
    it { should have_many(:locations) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it "requires a unique name regardless of case" do
      organisation = Organisation.create(name: "Parks & Rec Dept")
      expect {
        Organisation.create(name: "parks & rec dept")
      }.to_not change { Organisation.count }
    end
  end
end
