shared_context 'with confirmation use case spy' do
  require_relative './confirmation_use_case_spy'

  before do
    allow(UseCases::Administrator::SendConfirmationEmail).to \
      receive(:new).and_return(ConfirmationUseCaseSpy.new)
  end

  after do
    ConfirmationUseCaseSpy.clear!
  end
end
