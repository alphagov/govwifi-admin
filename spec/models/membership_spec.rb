describe Membership do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:user) }

  describe '.confirm!' do
    let(:inviter) { create(:user) }
    let(:user) { create(:user) }
    let(:organisation) { create(:organisation) }

    let(:invitation) do
      create(:membership,
             user: user,
             organisation: organisation,
             invitation_token: 'some_token',
             invited_by_id: inviter.id)
    end

    before do
      invitation.confirm!
    end

    it 'converts the invitation to an organisation' do
      expect(user.organisations.first).to eq(organisation)
    end

    it 'confirms the invitation' do
      expect(invitation.confirmed_at).not_to be_nil
    end
  end
end
