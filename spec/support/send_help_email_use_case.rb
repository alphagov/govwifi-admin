shared_examples 'send help email use case spy' do
  require_relative './send_help_email_use_case_spy'

  before do
    allow(UseCases::Administrator::SendHelpEmail).to \
      receive(:new).and_return(SendHelpEmailSpy.new)
  end

  after do
    SendHelpEmailSpy.clear!
  end
end
