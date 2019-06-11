require 'support/invite_use_case'
require 'support/membership_invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Inviting a user to their second or subsequent organisation', type: :feature do
  let(:inviter_organisation) { create(:organisation) }
  let(:betty) { create(:user, organisations: [inviter_organisation]) }
  let(:confirmed_user) { create(:user, :with_organisation) }

  include_examples 'when sending a membership invite email'
  include_examples 'when sending an invite email'

  context 'with a confirmed user' do
    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: betty.email
      click_on 'Send invitation email'
    end

    it 'sends a membership invitation' do
      expect(MembershipInviteUseCaseSpy.invite_count).to eq(1)
    end

    it 'does not send a new user invite' do
      expect(InviteUseCaseSpy.invite_count).to eq(0)
    end

    it 'creates a join organisation invitation' do
      expect(betty.memberships.count).to eq(2)
    end

    it 'notifies the user with a success message' do
      expect(page).to have_content("#{betty.email} has been invited to join #{confirmed_user.organisations.first.name}")
    end

    context 'when the invited user signs in aftwards' do
      before do
        sign_out
        sign_in_user betty
        visit confirm_new_membership_url(token: betty.membership_for(inviter_organisation).invitation_token)
      end

      it "changes your current organisation to this organisation" do
        within('.govuk-header') do
          expect(page.html).to include(inviter_organisation.name)
        end
      end
    end
  end

  context 'with an unconfirmed user' do
    let(:unconfirmed_email) { 'notconfirmedyet@gov.uk' }

    include_context 'when using the notifications service'

    before do
      sign_up_for_account(email: unconfirmed_email)
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: unconfirmed_email
      click_on 'Send invitation email'
    end

    it 'sends an invitation' do
      expect(InviteUseCaseSpy.invite_count).to eq(1)
    end
  end
end
