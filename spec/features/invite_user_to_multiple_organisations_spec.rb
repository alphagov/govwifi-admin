require 'support/invite_use_case'
require 'support/invite_use_case_spy'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Inviting a user to belong to multiple organisations', type: :feature do
  let(:user_org) { create(:organisation) }
  let(:user) { create(:user, organisations: [user_org]) }
  let(:invited_user_org) { create(:organisation) }
  let(:invited_user) { create(:user, organisations: [invited_user_org]) }
  let(:invite_link) { InviteUseCaseSpy.last_invite_url }

  before do
    sign_in_user user
    visit new_user_invitation_path
    fill_in 'Email', with: invited_user.email
    click_on 'Send invitation email'
    sign_out
  end

  it 'does not assign organisation when invite email is sent' do
    expect(invited_user.organisations).to eq([invited_user_org])
  end

  it 'assigns invited user to organisation when invitation is accepted' do
    visit invite_link
    expect(invited_user.organisations).to eq([user_org, invited_user_org])
  end

end
