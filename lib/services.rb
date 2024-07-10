module Services
  def self.notify_gateway
    @notify_gateway ||= Rails.application.config.notify_gateway.new(ENV.fetch("NOTIFY_API_KEY"))
  end

  def self.elasticsearch_client
    @elasticsearch_client ||= Elasticsearch::Client.new host: ENV["ELASTICSEARCH_ENDPOINT"]
  end
end
