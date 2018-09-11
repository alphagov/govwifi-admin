module Gateways
  class S3
    def initialize(bucket:, key:)
      @bucket = bucket
      @key = key
    end
  
    def upload(data:)
      s3 = Aws::S3::Resource.new(region: 'eu-west-1')
      b = s3.bucket(bucket)
      obj = b.object(key)

      obj.put(body: data.to_json)

      {}
    end
  
  private
  
    attr_reader :bucket, :key
  end
end