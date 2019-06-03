shared_context 'when sending a membership invite email' do
  require_relative './membership_invite_use_case_spy'

  before do
    allow(UseCases::Administrator::SendMembershipInviteEmail).to \
      receive(:new).and_return(MembershipInviteUseCaseSpy.new)
  end

  after do
    MembershipInviteUseCaseSpy.clear!
  end
end
