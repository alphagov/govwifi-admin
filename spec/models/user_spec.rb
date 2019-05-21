describe User do
  it { is_expected.to have_many(:organisations).through(:memberships) }
  it { is_expected.to have_many(:memberships) }
  it { is_expected.to validate_presence_of(:name).on(:update) }

  context 'when creating a user without explicit permissions' do
    subject(:user) { create(:user) }

    it 'receives default permission to manage team members' do
      expect(user).to be_can_manage_team
    end

    it 'receives default permission to manage locations' do
      expect(user).to be_can_manage_locations
    end
  end
end
