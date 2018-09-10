describe Location do
  context 'associations' do
    it { should belong_to(:organisation) }
    it { should have_many(:ips) }
  end

  describe "#save" do
    let(:organisation) { create(:organisation) }
    subject { build(:location, organisation: organisation) }
    before do
      subject.save
    end

    it 'sets the radius_secret_key' do
      expect(subject.radius_secret_key).to be_present
    end
  end
end
