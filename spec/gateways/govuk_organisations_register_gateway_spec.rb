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
  end
end
