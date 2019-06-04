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

  describe '.default_membership' do
    context 'with no memberships' do
      let(:user) { create(:user) }

      it 'returns nil' do
        expect(user.default_membership).to eq(nil)
      end
    end

    context 'with memberships' do
      let(:organisation_1) { create(:organisation) }
      let(:organisation_2) { create(:organisation) }
      let(:user) { create(:user, organisations: [organisation_1]) }

      before do
        user.organisations << organisation_2
      end

      it 'returns the first one' do
        expect(user.default_membership).to eq(user.membership_for(organisation_1))
      end
    end
  end
end
