module UseCases
  module Administrator
    class SendHelpEmail
      REFERENCE = 'help_email'.freeze

      def initialize(notifications_gateway:)
        @notifications_gateway = notifications_gateway
      end

      def execute(email:, sender_email:, name:, organisation:, details:, phone:, subject:, template_id:)
        opts = {
          email: email,
          locals: {
            details: details,
            name: name,
            subject: subject,
            sender_email: sender_email,
            phone: phone,
            organisation: organisation
          },
          template_id: template_id,
          reference: REFERENCE,
          email_reply_to_id: nil
        }

        notifications_gateway.send(opts)
      end

    private

      attr_reader :notifications_gateway
    end
  end
end
