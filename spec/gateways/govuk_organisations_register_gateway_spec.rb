describe Gateways::GovukOrganisationsRegisterGateway do
  subject(:register_gateway) { described_class.new }

  context "when custom organisations are added" do
    before do
      CustomOrganisationName.create!(name: "Custom Org 1")
      CustomOrganisationName.create!(name: "Custom Org 2")
    end

    it "fetches the custom organisation names from the register" do
      result = register_gateway.custom_orgs
      expect(result).to eq(["Custom Org 1", "Custom Org 2"])
    end

    it "fetches all organisation names" do
      result = register_gateway.all_orgs
      expect(result).to include("Gov Org 1")
      expect(result).to include("Custom Org 1")
      expect(result).to include("Local Auth 1")
    end
  end
end
