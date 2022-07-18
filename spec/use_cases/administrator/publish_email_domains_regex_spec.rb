describe UseCases::Administrator::PublishEmailDomainsRegex do
  let(:prefix) { UseCases::Administrator::PublishEmailDomainsRegex::SIGNUP_ALLOWLIST_PREFIX_MATCHER }

  subject(:result) { Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read }

  context "when no domains" do
    it "creates no allowlist" do
      UseCases::Administrator::PublishEmailDomainsRegex.new.publish
      expect(result).to eq("^$")
    end
  end

  context "when one domain" do
    before :each do
      AuthorisedEmailDomain.create!(name: "gov.uk")
      UseCases::Administrator::PublishEmailDomainsRegex.new.publish
    end
    it "creates a allowlist with one entry" do
      expect(result).to eq("#{prefix}(gov\\.uk)$")
    end
  end

  context "when multiple domains" do
    before :each do
      AuthorisedEmailDomain.create!(name: "gov.uk")
      AuthorisedEmailDomain.create!(name: "police.uk")
      UseCases::Administrator::PublishEmailDomainsRegex.new.publish
    end
    it "creates a allowlist with multiple entries" do
      expect(result).to eq("#{prefix}(gov\\.uk|police\\.uk)$")
    end
  end
end
