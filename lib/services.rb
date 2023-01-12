module Services
  def self.email_gateway
    Gateways::EmailGateway
  end

  def self.elasticsearch_client
    @elasticsearch_client ||= Elasticsearch::Client.new host: ENV["ELASTICSEARCH_ENDPOINT"]
  end
end
