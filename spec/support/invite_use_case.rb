shared_examples 'invite use case spy' do
  require_relative './invite_use_case_spy'

  before do
    allow(SendInviteEmail).to \
      receive(:new).and_return(InviteUseCaseSpy.new)
  end

  after do
    InviteUseCaseSpy.clear!
  end
end
