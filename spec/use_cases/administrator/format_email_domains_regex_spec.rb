describe UseCases::Administrator::FormatEmailDomainsRegex do
  let(:result) { subject.execute(authorised_domains) }

  context "when no domains" do
    let(:authorised_domains) { [] }

    it "creates no allowlist" do
      expect(result).to eq("^$")
    end
  end

  context "when one domain" do
    let(:authorised_domains) { %w[gov.uk] }

    it "escapes the fullstops" do
      expect(result).to include('\.')
    end

    it "creates a allowlist with one entry" do
      expect(result).to eq("#{SIGNUP_ALLOWLIST_PREFIX_MATCHER}(gov\\.uk)$")
    end
  end

  context "when multiple domains" do
    let(:authorised_domains) { %w[gov.uk police.uk some.domain.org.uk] }

    it "creates a allowlist with multiple entries" do
      expect(result).to eq("#{SIGNUP_ALLOWLIST_PREFIX_MATCHER}(gov\\.uk|police\\.uk|some\\.domain\\.org\\.uk)$")
    end
  end
end
