describe 'Confirming a cross organisation invitation', type: :feature do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:user, organisations: [organisation]) }
  let(:invited_user) { create(:user, :with_organisation) }
  let(:token) { 'abc123' }

  context 'with an existing user' do
    before do
      create(:membership,
             user: invited_user,
             invited_by_id: user.id,
             organisation: organisation,
             invitation_token: token)

      sign_in_user invited_user
      visit membership(token: token)
    end

    it 'Confirms the invitation' do
      expect(invited_user.organisations).to include(organisation)
    end

    it 'prints a success message' do
      expect(page).to have_content("You have successfully joined #{organisation.name}")
    end
  end
end
