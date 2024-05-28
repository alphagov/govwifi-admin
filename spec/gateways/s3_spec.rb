describe Gateways::S3 do
  subject(:gateway) { described_class.new(bucket:, key:) }

  it "can write and read from a bucket" do
    Gateways::S3.new(bucket: "bucket", key: "key").write("Hello world")
    expect(Gateways::S3.new(bucket: "bucket", key: "key").read).to eq("Hello world")
  end

  it "can write StringIO as well" do
    Gateways::S3.new(bucket: "bucket", key: "key").write(StringIO.new("Hello world"))
    expect(Gateways::S3.new(bucket: "bucket", key: "key").read).to eq("Hello world")
  end

  it "it does not read what has not been written" do
    Gateways::S3.new(bucket: "bucket", key: "key").write("Hello world")
    expect(Gateways::S3.new(bucket: "bucket", key: "another-key").read).to be_empty
  end
end
