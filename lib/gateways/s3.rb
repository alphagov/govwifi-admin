module Gateways
  class S3
    def initialize(bucket:, key:)
      @bucket = bucket
      @key = key
      @client = Aws::S3::Client.new(config)
    end

    def write(data:)
      client.put_object(
        body: data,
        bucket:,
        key:,
      )

      {}
    end

    def read
      client.get_object(bucket:, key:).body.read
    end

  private

    DEFAULT_REGION = "eu-west-2".freeze

    attr_reader :bucket, :key, :client

    def config
      { region: DEFAULT_REGION }.merge(Rails.application.config.s3_aws_config)
    end
  end
end
