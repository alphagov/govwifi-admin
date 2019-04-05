shared_context 'when sending an invite email' do
  require_relative './invite_use_case_spy'

  before do
    allow(UseCases::Administrator::SendInviteEmail).to \
      receive(:new).and_return(InviteUseCaseSpy.new)
  end

  after do
    InviteUseCaseSpy.clear!
  end
end
