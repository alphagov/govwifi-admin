module Services
  def self.email_gateway
    @email_gateway ||= Rails.application.config.email_gateway.new
  end

  def self.elasticsearch_client
    @elasticsearch_client ||= Elasticsearch::Client.new host: ENV["ELASTICSEARCH_ENDPOINT"]
  end

  def self.certificate_repository
    @certificate_repository ||= Rails.application.config.certificate_repository.new
  end
end
