describe User do
  let(:organisation) { create(:organisation) }

  it { is_expected.to have_many(:organisations).through(:memberships) }
  it { is_expected.to have_many(:memberships) }
  it { is_expected.to validate_presence_of(:name).on(:update) }

  context 'when checking if a membership is pending' do
    subject(:user) { create(:user, organisations: [organisation]) }

    let(:organisation) { create(:organisation) }

    it 'returns true if the membership is pending' do
      expect(user.pending_membership_for?(organisation: organisation)).to eq(true)
    end
  end
end
