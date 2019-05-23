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

  context 'when checking if a membership is pending' do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:organisation) { create(:organisation) }

    it 'returns true if the membership is pending' do
      expect(user.pending_membership_for?(organisation: organisation)).to eq(true)
    end
  end
end
