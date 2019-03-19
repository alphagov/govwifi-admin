describe Gateways::S3 do
  subject { described_class.new(bucket: bucket, key: key) }

  let(:bucket) { 'StubBucket' }
  let(:key) { 'StubKey' }
  let(:data) { { blah: 'foobar' }.to_json }


  it 'writes the data to the bucket' do
    expect(subject.write(data: data)).to eq({})
  end

  context 'when we read from the S3 file' do
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

    it 'returns the contents' do
      expect(subject.read).to eq('some data')
    end
  end
end
