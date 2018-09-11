describe Gateways::S3 do
  let(:bucket) { 'StubBucket' }
  let(:key) { 'StubKey' }
  let(:data) { { blah: "foobar" } }

  subject { described_class.new(bucket: bucket, key: key) }

  it 'uploads the data' do
    expect(subject.upload(data: data)).to eq({})
  end
end
