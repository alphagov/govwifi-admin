shared_examples 'confirmation use case spy' do
  require_relative './confirmation_use_case_spy'

  before do
    allow(SendConfirmationEmail).to \
      receive(:new).and_return(ConfirmationUseCaseSpy.new)
  end

  after do
    ConfirmationUseCaseSpy.clear!
  end
end
