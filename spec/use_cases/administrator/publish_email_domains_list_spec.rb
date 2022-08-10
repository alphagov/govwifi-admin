describe UseCases::Administrator::PublishEmailDomainsList do
  subject(:result) { Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).read }

  context "with no email domains" do
    it "creates no allowlist" do
      UseCases::Administrator::PublishEmailDomainsList.new.publish
      expect(result).to eq("--- []\n")
    end
  end

  context "when two email domains are added" do
    before :each do
      AuthorisedEmailDomain.create!(name: "gov.uk")
      AuthorisedEmailDomain.create!(name: "made.eu")
      UseCases::Administrator::PublishEmailDomainsList.new.publish
    end

    it "creates a allowlist with two entries" do
      expect(result).to eq("---\n- gov.uk\n- made.eu\n")
    end
  end
end
