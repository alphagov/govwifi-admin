shared_examples 'support email use case spy' do
  require_relative './support_email_use_case_spy'

  before do
    allow(SendConfirmationEmail).to \
      receive(:new).and_return(ConfirmationUseCaseSpy.new)
  end

  after do
    ConfirmationUseCaseSpy.clear!
  end
end