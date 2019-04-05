shared_context 'when sending a confirmation email' do
  require_relative './confirmation_use_case_spy'

  before do
    allow(UseCases::Administrator::SendConfirmationEmail).to \
      receive(:new).and_return(ConfirmationUseCaseSpy.new)
  end

  after do
    ConfirmationUseCaseSpy.clear!
  end
end
