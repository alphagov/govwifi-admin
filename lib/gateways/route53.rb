module Gateways
  class Route53
    def initialize
      @client = Aws::Route53::Client.new(config)
    end

    delegate :list_health_checks, to: :client

    def get_health_check_status(health_check_id:)
      client.get_health_check_status(health_check_id:)
    end

  private

    DEFAULT_REGION = "eu-west-2".freeze

    attr_reader :client

    def config
      { region: DEFAULT_REGION }.merge(Rails.application.config.route53_aws_config)
    end
  end
end
