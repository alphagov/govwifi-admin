module UseCases
  module Administrator
    class NotifySupportOfNewUser
      REFERENCE = 'notify_support_of_new_user'.freeze

      def initialize(notifications_gateway:)
        @notifications_gateway = notifications_gateway
      end

      def execute(new_user_email:, template_id:)
        opts = {
          email: GOV_NOTIFY_CONFIG['support_email'],
          locals: { user_email: new_user_email },
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
