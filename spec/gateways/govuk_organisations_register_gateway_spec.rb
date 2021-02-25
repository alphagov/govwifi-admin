describe Gateways::GovukOrganisationsRegisterGateway do
  subject(:register_gateway) { described_class.new }

  it "fetches the organisation names from the register" do
    result = register_gateway.government_orgs
    expect(result).to eq(["Gov Org 1", "Gov Org 2", "Gov Org 3", "Gov Org 4"])
  end

  it "fetches the local authority names from the register" do
    result = register_gateway.local_authorities
    expect(result).to eq(["Local Auth 1", "Local Auth 2", "Local Auth 3", "Local Auth 4"])
  end

  context "when custom organisations are added" do
    before do
      CustomOrganisationName.create!(name: "Custom Org 1")
      CustomOrganisationName.create!(name: "Custom Org 2")
    end

    it "fetches the custom organisation names from the register" do
      result = register_gateway.custom_orgs
      expect(result).to eq(["Custom Org 1", "Custom Org 2"])
    end
  end
end
