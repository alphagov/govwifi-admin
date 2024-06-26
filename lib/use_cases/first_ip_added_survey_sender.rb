# frozen_string_literal: true

module UseCases
  class FirstIpAddedSurveySender
    def execute(user, current_organisation)
      return if user.sent_first_ip_survey? || current_organisation.ips.count.positive?

      GovWifiMailer.send_survey(user.email).deliver_now
      user.update!(sent_first_ip_survey: true)
    end
  end
end
