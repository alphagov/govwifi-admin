require 'support/membership_invite_use_case'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Inviting an existing user', type: :feature do
  let(:inviter_organisation) { create(:organisation) }
  let(:betty) { create(:user, organisations: [inviter_organisation]) }
  let(:confirmed_user) { create(:user, :with_organisation) }

  include_examples 'when sending a membership invite email'

  context 'with a confirmed user' do
    before do
      sign_in_user confirmed_user
      visit new_user_invitation_path
      fill_in 'Email', with: betty.email
      click_on 'Send invitation email'
    end

    it 'sends an invitation' do
      expect(MembershipInviteUseCaseSpy.invite_count).to eq(1)
    end

    it 'creates a join organisation invitation' do
      expect(betty.memberships.count).to eq(2)
    end

    it 'notifies the user with a success message' do
      expect(page).to have_content("#{betty.email} has been invited to join #{confirmed_user.organisations.first.name}")
    end

    context 'when I confirm the invitation' do
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
end
