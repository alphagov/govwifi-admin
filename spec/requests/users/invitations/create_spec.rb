require 'support/invite_use_case'
require 'support/notifications_service'

describe "POST /users/invitation", type: :request do
  let(:user) { create(:user) }
  let(:organisation) { user.organisation }

  before do
    https!
    login_as(user, scope: :user)
  end

  include_examples 'notifications service'
  include_examples 'with invite use case spy'

  context 'with tampered organisation_id parameter' do
    let(:email) { 'barry@gov.uk' }
    let(:other_organisation) { create(:organisation) }

    before do
      post user_invitation_path, params: { user: {
        email: email,
        organisation_id: other_organisation.id
      } }
    end

    it 'invites a user' do
      expect(InviteUseCaseSpy.invite_count).to eq(1)
    end

    it 'ignores provided organisation_id' do
      expect(User.find_by(email: email).organisation_id).to eq(organisation.id)
    end
  end
end
