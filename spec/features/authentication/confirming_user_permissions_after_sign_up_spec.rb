require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'
require 'support/notifications_service'
require 'support/confirmation_use_case'

# This may not be a neccessary spec, but was done for diagnosing the bug
describe 'User permissions from sign up pathway', focus: true do
  include_examples 'notifications service'

  before { sign_up_for_account(email: email) }

  context 'when the user has not confirmed their account' do
    let(:name) { 'Julie' }
    let(:email) { 'anotheradmin@gov.uk' }
    let(:user) { User.find_by(email: email) }

    it 'keeps the default permissions' do
      expect(user.permission.can_manage_team?).to eq(true)
      expect(user.permission.can_manage_locations?).to eq(true)
    end
  end

  context 'when the user has confirmed their account' do
    let(:name) { 'Sara' }
    let(:email) { 'someadmin@gov.uk' }
    let(:user) { User.find_by(email: email) }

    it 'keeps the default permissions' do
      update_user_details(name: name, organisation_name: "The Bug Exterminators")

      expect(user.permission.can_manage_team?).to eq(true)
      expect(user.permission.can_manage_locations?).to eq(true)
    end
  end
end
