module UseCases
  module Administrator
    class SendOtpEmail
      REFERENCE = "otp_email".freeze

      def initialize(notifications_gateway:)
        @notifications_gateway = notifications_gateway
      end

      def execute(email_address:, url:, name:)
        opts = {
          email: email_address,
          locals: { url:, name: },
          template_id: GOV_NOTIFY_CONFIG["otp_email"]["template_id"],
          reference: REFERENCE,
          email_reply_to_id: nil,
        }

        notifications_gateway.send(opts)
      end

    private

      attr_reader :notifications_gateway
    end
  end
end
