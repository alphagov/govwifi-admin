describe 'Confirming a cross organisation invitation' do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:invited_user) { create(:user, :with_organisation) }
  let(:token) { 'abc123' }

  context 'with an existing user' do
    before do
      create(:cross_organisation_invitation,
             user: invited_user,
             invited_by_id: user.id,
             organisation: organisation,
             invitation_token: token)

      sign_in_user invited_user
      visit confirm_cross_organisation_invitations_path(token: token)
    end

    it 'Confirms the invitation' do
      expect(invited_user.organisations).to include(organisation)
    end

    it 'prints a success message' do
      expect(page).to have_content("You have successfully joined #{organisation.name}")
    end
  end
end
