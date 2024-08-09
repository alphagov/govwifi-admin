module Services
  def self.notify_gateway
    @notify_gateway ||= Rails.application.config.notify_gateway.new(ENV.fetch("NOTIFY_API_KEY"))
  end

  def self.opensearch_client
    @opensearch_client ||= OpenSearch::Client.new host: ENV["ELASTICSEARCH_ENDPOINT"],
    log: true
  end
end
