describe User do
  context 'associations' do
    it { is_expected.to belong_to(:organisation).optional }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name).on(:update) }
  end

  context 'permissions' do
    context 'a new user' do
      subject { create(:user) }

      it 'can manage team members' do
        expect(subject).to be_can_manage_team
      end

      it 'can manage locations' do
        expect(subject).to be_can_manage_locations
      end
    end
  end
end
