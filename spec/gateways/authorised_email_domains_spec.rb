describe Gateways::AuthorisedEmailDomains do
  subject(:domain_gateway) { described_class.new }

  let(:result) do
    [
      "gov.uk",
      "eukri.gsi.com",
    ]
  end

  before do
    create(:authorised_email_domain, name: "gov.uk")
    create(:authorised_email_domain, name: "eukri.gsi.com")
  end

  it "fetches the locations ips" do
    expect(domain_gateway.fetch_domains).to match_array(result)
  end
end
