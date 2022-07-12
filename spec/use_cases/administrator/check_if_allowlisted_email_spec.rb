describe UseCases::Administrator::CheckIfAllowlistedEmail do
  subject(:use_case) { described_class.new(gateway: s3_gateway) }

  let(:s3_gateway) { instance_double("Gateways::S3", read: '^.*@(aaa\.uk)$') }

  context "when a allowlisted email" do
    it "accepts an address matching the regex" do
      result = use_case.execute("someone@aaa.uk")
      expect(result).to eq(success: true)
    end

    it "accepts an address matching the regex regardless of case" do
      result = use_case.execute("SOMEONE@AAA.UK")
      expect(result).to eq(success: true)
    end
  end

  context "when a non-allowlisted email" do
    it "rejects an address not matching the regex" do
      result = use_case.execute("someone@bbb.uk")
      expect(result).to eq(success: false)
    end
  end

  context "when an invalid email" do
    it "rejects an empty email address" do
      result = use_case.execute("")
      expect(result).to eq(success: false)
    end

    it "rejects a nil address" do
      result = use_case.execute(nil)
      expect(result).to eq(success: false)
    end

    it "respects subdomains" do
      result = use_case.execute("someone@aaauk")
      expect(result).to eq(success: false)
    end
  end
end
