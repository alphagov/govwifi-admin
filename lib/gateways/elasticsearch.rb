require "elasticsearch"

class Gateways::Elasticsearch
  def initialize(index)
    @index = index
  end

  def write(key, data)
    Services.elasticsearch_client.index(
      index: @index,
      id: key,
      body: data,
    )
  end
end
