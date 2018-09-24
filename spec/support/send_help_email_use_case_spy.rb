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

  def execute(email:, sender_email:, name:, organisation:, details:, phone:, subject:, template_id:)
    @@support_emails_count += 1

    {}
  end
end
