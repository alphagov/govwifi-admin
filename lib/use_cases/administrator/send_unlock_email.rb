module UseCases
  module Administrator
    class SendUnlockEmail
      REFERENCE = "unlock_account".freeze

      def initialize(notifications_gateway:)
        @notifications_gateway = notifications_gateway
      end

      def execute(email:, unlock_url:, template_id:)
        opts = {
          email:,
          locals: { unlock_url: },
          template_id:,
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
