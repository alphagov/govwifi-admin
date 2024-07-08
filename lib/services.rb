module Services
  def self.email_gateway
    @email_gateway ||= Rails.application.config.email_gateway.new
  end

  def self.sms_gateway
    @sms_gateway ||= Rails.application.config.sms_gateway.new
  end

  def self.elasticsearch_client
    @elasticsearch_client ||= Elasticsearch::Client.new host: ENV["ELASTICSEARCH_ENDPOINT"]
  end
end
