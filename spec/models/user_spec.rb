describe User do
  context 'associations' do
    it { is_expected.to belong_to(:organisation) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name).on(:update) }
  end

  context 'permissions' do
    context 'a new user' do
      subject { create(:user) }

      it 'can manage team members' do
        expect(subject.can_manage_team?).to be_truthy
      end

      it 'can manage locations' do
        expect(subject.can_manage_locations?).to be_truthy
      end
    end
  end
end
