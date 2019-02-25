describe Gateways::S3 do
  let(:bucket) { 'StubBucket' }
  let(:key) { 'StubKey' }
  let(:data) { { blah: 'foobar' }.to_json }

  subject { described_class.new(bucket: bucket, key: key) }

  it 'uploads the data' do
    expect(subject.upload(data: data)).to eq({})
  end

  context 'given we read from the S3 file' do
    before do
      Rails.application.config.s3_aws_config = {
        stub_responses: {
          get_object: ->(context) {
            if context.params.fetch(:bucket) == bucket && context.params.fetch(:key) == key
              { body: 'some data' }
            end
          }
        }
      }
    end

    after do
      Rails.application.config.s3_aws_config = { stub_responses: true }
    end

    it 'returns the contents' do
      expect(subject.read).to eq('some data')
    end
  end
end
