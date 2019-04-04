require 'support/invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Inviting an existing user', type: :feature do
  let(:betty) { create(:user) }
  let(:confirmed_user) { create(:user) }

  include_examples 'with invite use case spy'

  context 'with a confirmed user' do
    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: betty.email
      click_on 'Send invitation email'
    end

    it 'does not send an invitation' do
      expect(InviteUseCaseSpy.invite_count).to eq(0)
    end

    it 'displays the correct error message' do
      expect(page).to have_content("Email is already associated with an account. If you can't sign in, reset your password")
    end

    context 'when the invited user signs in afterwards' do
      before do
        sign_in_user betty
        visit root_path
      end

      it 'allows the user to sign in successfully' do
        expect(page).to have_content 'Sign out'
      end

      it 'has no errors upon signing in' do
        expect(page).not_to have_content('An error occurred')
      end

      it 'does not change their manage team permissions' do
        expect(betty.permission.can_manage_team?).to eq(true)
      end

      it 'does not change their manage location permissions' do
        expect(betty.permission.can_manage_locations?).to eq(true)
      end
    end
  end

  context 'with an unconfirmed user' do
    let(:unconfirmed_email) { 'notconfirmedyet@gov.uk' }

    # rubocop:disable RSpec/HooksBeforeExamples
    include_examples 'notifications service'

    before do
      sign_up_for_account(email: unconfirmed_email)
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: unconfirmed_email
      click_on 'Send invitation email'
    end
    # rubocop:enable RSpec/HooksBeforeExamples

    it 'sends an invitation' do
      expect(InviteUseCaseSpy.invite_count).to eq(1)
    end
  end
end
