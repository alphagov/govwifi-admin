describe CrossOrganisationInvitation do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:user) }

  let(:inviter) { create(:user) }
  let(:user) { create(:user) }
  let(:organisation) { create(:organisation) }
  let(:invitation) do
    create(:cross_organisation_invitation,
           user: user,
           organisation: organisation,
           invitation_token: 'some_token',
           invited_by_id: inviter.id)
  end

  describe '.confirm!' do
    before do
      invitation.confirm!
    end

    it 'converts the invitation to an organisation' do
      expect(user.organisations).to eq([organisation])
    end

    it 'confirms the invitation' do
      expect(invitation.confirmed_at).not_to be_nil
    end
  end

  describe '.pending' do
    it 'includes unconfirmed invitations' do
      expect(described_class.pending).to eq([invitation])
    end

    it 'excludes unconfirmed invitations' do
      invitation.confirm!
      expect(described_class.pending).to be_empty
    end
  end
end
