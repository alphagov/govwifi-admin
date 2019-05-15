describe User do
  subject(:user) { create(:user) }

  it { is_expected.to have_and_belong_to_many(:organisations) }
  it { is_expected.to have_many(:cross_organisation_invitations) }
  it { is_expected.to validate_presence_of(:name).on(:update) }

  context 'when creating a user without explicit permissions' do
    it 'receives default permission to manage team members' do
      expect(user).to be_can_manage_team
    end

    it 'receives default permission to manage locations' do
      expect(user).to be_can_manage_locations
    end
  end

  describe '.cross_organisation_invitation_pending?' do
    let(:organisation) { create(:organisation) }

    context 'when the invite exists' do
      before do
        create(:cross_organisation_invitation,
               user: user,
               organisation: organisation,
               invitation_token: 'some_token',
               invited_by_id: create(:user).id)
      end

      it 'returns true if we have a pending invitation to the organisation' do
        expect(user.has_pending_invites_for_organisation?(organisation)).to eq(true)
      end

      it 'returns false if the invitation is confirmed' do
        user.cross_organisation_invitations.first.confirm!

        expect(user.has_pending_invites_for_organisation?(organisation)).to eq(false)
      end
    end
  end
end
