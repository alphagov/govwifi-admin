describe UseCases::Administrator::CheckIfAllowlistedEmail do
  before :each do
    Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).write("^.*@(aaa\.uk)$")
  end
  context "when a allowlisted email" do
    it "accepts an address matching the regex" do
      result = described_class.execute("someone@aaa.uk")
      expect(result).to eq(true)
    end

    it "accepts an address matching the regex regardless of case" do
      result = described_class.execute("SOMEONE@AAA.UK")
      expect(result).to eq(true)
    end
  end

  context "when a non-allowlisted email" do
    it "rejects an address not matching the regex" do
      result = described_class.execute("someone@bbb.uk")
      expect(result).to eq(false)
    end
  end

  context "when an invalid email" do
    it "rejects an empty email address" do
      result = described_class.execute("")
      expect(result).to eq(false)
    end

    it "rejects a nil address" do
      result = described_class.execute(nil)
      expect(result).to eq(false)
    end

    it "respects subdomains" do
      result = described_class.execute("someone@aaauk")
      expect(result).to eq(false)
    end
  end
end
