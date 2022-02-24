describe Gateways::OrganisationUsers do
  subject(:gateway) { described_class.new(organisation:) }

  context "with users" do
    let(:organisation) { create(:organisation) }
    let(:result) do
      organisation.users
    end

    before do
      create_list :user, 3, organisations: [organisation]
      create(:user, :with_organisation)
    end

    it "fetches the users for the organisation" do
      expect(gateway.fetch).to eq(result)
    end

    it "returns an ActiveRecord collection" do
      expect(gateway.fetch.class.ancestors).to include(ActiveRecord::Relation)
    end
  end

  context "without users" do
    let(:organisation) { create(:organisation) }

    it "returns an empty collection" do
      expect(gateway.fetch).to eq([])
    end
  end
end
