module Gateways
  class S3
    def initialize(bucket:, key:)
      @bucket = bucket
      @key = key
    end

    def upload(data:)
      client = Aws::S3::Client.new(config)
      client.put_object({
        body: data.to_json,
        bucket: bucket,
        key: key,
      })

      {}
    end

  private

    DEFAULT_REGION = 'eu-west-2'.freeze

    attr_reader :bucket, :key

    def config
      { region: DEFAULT_REGION }.merge(Rails.application.config.aws_config)
    end
  end
end
