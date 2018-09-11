describe Gateways::S3 do
  let(:bucket) { 'StubBucket' }
  let(:key) { 'StubKey' }
  let(:data) { { blah: "foobar" } }

  subject { described_class.new(bucket: bucket, key: key) }

  before do
    ENV['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI'] = '/stubUri'

    stub_request(:get, 'http://169.254.170.2/stubUri').to_return(body: {
      'AccessKeyId': 'ACCESS_KEY_ID',
      'Expiration': (Time.now + 60).iso8601,
      'RoleArn': 'TASK_ROLE_ARN',
      'SecretAccessKey': 'SECRET_ACCESS_KEY',
      'Token': 'SECURITY_TOKEN_STRING'
    }.to_json)

    stub_request(:put, "https://s3.eu-west-1.amazonaws.com/#{bucket}/#{key}") \
      .with({
        body: data.to_json
      })
  end

  it 'uploads the data' do
    expect(subject.upload(data: data)).to eq({})
  end
end
