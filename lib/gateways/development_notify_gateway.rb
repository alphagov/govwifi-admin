require "notifications/client"

module Gateways
  class DevelopmentNotifyGateway
    def initialize(_); end

    def send_email(opts)
      Rails.logger.info "Stub email to: #{opts[:email]}"
      Rails.logger.info "...Notifiy TemplateId: #{opts[:template_id]}"
      Rails.logger.info "...Personalisation: #{opts[:personalisation]}"
      Rails.logger.info "...Reference: #{opts[:reference]}"
    end

    def send_sms(opts)
      Rails.logger.info "Stub sms to: #{opts[:contact]}"
      Rails.logger.info "...Notifiy TemplateId: #{opts[:template_id]}"
      Rails.logger.info "...Personalisation: #{opts[:personalisation]}"
    end

    def get_all_templates
      OpenStruct.new(collection:
                       NotifyTemplates::TEMPLATES.map { |name| OpenStruct.new(name:, id: "#{name}_template") })
    end
  end
end
