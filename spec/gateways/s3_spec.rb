describe Gateways::S3 do
  subject(:gateway) { described_class.new(bucket:, key:) }

  let(:bucket) { "StubBucket" }
  let(:key) { "StubKey" }
  let(:data) { { blah: "foobar" }.to_json }

  it "writes the data to the S3 bucket" do
    expect(gateway.write(data:)).to eq({})
  end

  context "when reading a file from the S3 bucket" do
    before do
      Rails.application.config.s3_aws_config = {
        stub_responses: {
          get_object: lambda { |context|
            if context.params.fetch(:bucket) == bucket && context.params.fetch(:key) == key
              { body: "some data" }
            end
          },
        },
      }
    end

    it "returns the contents of the file" do
      expect(gateway.read).to eq("some data")
    end
  end
end
