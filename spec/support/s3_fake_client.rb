# frozen_string_literal: true

module S3FakeClient
  def self.new_instance
    fake_s3 = {}
    Aws::S3::Client.new(stub_responses: true).tap do |client|
      client.stub_responses(
        :put_object, lambda { |context|
                       bucket = context.params[:bucket]
                       key = context.params[:key]
                       body = context.params[:body]
                       fake_s3[bucket] ||= {}
                       fake_s3[bucket][key] = body
                       {}
                     }
      )
      client.stub_responses(
        :get_object, lambda { |context|
                       bucket = context.params[:bucket]
                       key = context.params[:key]
                       { body: fake_s3.dig(bucket, key) }
                     }
      )
      client.stub_responses(
        :list_objects_v2,
        lambda { |context|
          bucket = context.params[:bucket]
          continuation_token = context.params[:continuation_token]
          prefix = context.params[:prefix]

          keys = fake_s3[bucket].keys
                                .select { |k| !prefix || k.slice(0, prefix.length) == prefix }
                                .map { |key| { key: } }

          continuation_token && {
            contents: keys[1000..1999],
          } || {
            contents: keys[0..999],
            is_truncated: true,
            next_continuation_token: "foo",
          }
        },
      )
    end
  end
end
