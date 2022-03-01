module UseCases
  module Administrator
    class SendMembershipInviteEmail
      REFERENCE = "invite_email".freeze

      def initialize(notifications_gateway:)
        @notifications_gateway = notifications_gateway
      end

      def execute(email:, invite_url:, template_id:, organisation:)
        opts = {
          email:,
          locals: { invite_url:, organisation: organisation.name },
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
