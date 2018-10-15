shared_context 'with SendHelpEmail mocked' do
  before do
    allow(UseCases::Administrator::SendHelpEmail)
      .to receive(:new)
      .and_return(SendHelpEmailSpy.new)
  end

  after do
    SendHelpEmailSpy.clear!
  end
end

# rubocop:disable Style/ClassVars
class SendHelpEmailSpy
  @@support_emails_count = 0

  class << self
    def support_emails_sent_count
      @@support_emails_count
    end

    def clear!
      @@support_emails_count = 0
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def execute(email:, sender_email:, name:, organisation:, details:, phone:, subject:, template_id:)
    @@support_emails_count += 1

    {}
  end
  # rubocop:enable Lint/UnusedMethodArgument
end
# rubocop:enable Style/ClassVars
