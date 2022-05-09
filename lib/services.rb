module Services
  def self.email_gateway
    Gateways::EmailGateway
  end

  def self.s3_client
    config = { region: DEFAULT_REGION }.merge(Rails.application.config.s3_aws_config)
    Aws::S3::Client.new(config)
  end
end
