# frozen_string_literal: true

module UseCases
  class FirstIpAddedSurveySender
    def execute(user, current_organisation)
      return if user.sent_first_ip_survey? || current_organisation.ips.count.positive?

      send_survey(user.email)
      user.update!(sent_first_ip_survey: true)
    end

  private

    def send_survey(email_address)
      opts = {
        email: email_address,
        locals: {},
        template_id: GOV_NOTIFY_CONFIG["first_ip_survey"]["template_id"],
        reference: "first_ip_survey",
      }
      Services.email_gateway.send_email(opts)
    end
  end
end
