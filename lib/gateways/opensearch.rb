require "opensearch-ruby"

class Gateways::Opensearch
  def initialize(index)
    @index = index
  end

  def write(key, data)
    Services.opensearch_client.index(
      index: @index,
      id: key,
      body: data,
    )
  end
end
