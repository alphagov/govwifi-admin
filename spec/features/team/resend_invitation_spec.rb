require 'support/invite_use_case_spy'
require 'support/invite_use_case'
require 'support/notifications_service'

describe 'Resending an invitation to a team member', type: :feature do
  let(:invited_user_email) { 'invited@gov.uk' }
  let(:user) { create(:user) }

  include_examples 'invite use case spy'
  include_context 'when using the notifications service'

  # rubocop:disable RSpec/HooksBeforeExamples
  before do
    sign_in_user user
    invite_user(invited_user_email)
    visit team_members_path
  end
  # rubocop:enable RSpec/HooksBeforeExamples

  it 'shows that the invitation is pending' do
    expect(page).to have_content('invited')
  end

  it 'sends an invitation' do
    expect { click_on 'Resend invite' }.to \
      change(InviteUseCaseSpy, :invite_count).by(1)
  end

  it 'redirects to the "after resending invite" path for analytics' do
    click_on 'Resend invite'
    expect(page).to have_current_path('/team_members/recreated/invite')
  end

  context 'when signing up from the resent invitation' do
    let(:invite_link) { InviteUseCaseSpy.last_invite_url }
    let(:invited_user) { User.find_by(email: invited_user_email) }

    before do
      visit invite_link
    end

    it 'displays the sign up page' do
      expect(page).to have_content('Create your account')
    end

    context 'when filling in the sign up page' do
      before do
        fill_in 'Your name', with: 'Ron Swanson'
        fill_in 'Password', with: 'password'
        click_on 'Create my account'
      end

      it 'saves the users name' do
        expect(invited_user.name).to eq('Ron Swanson')
      end

      it 'confirms the user' do
        expect(invited_user.confirmed?).to eq(true)
      end
    end
  end
end
