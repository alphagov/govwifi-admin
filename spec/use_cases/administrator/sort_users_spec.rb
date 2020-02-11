describe UseCases::Administrator::SortUsers do
  subject(:use_case) { described_class.new(users_gateway: gateway) }

  let(:user_collection) { instance_spy("User::ActiveRecord_Relation", order: nil) }
  let(:gateway) do
    instance_spy("Gateways::OrganisationUsers", fetch: user_collection)
  end

  context "when calling execute" do
    let(:valid_order_query) do
      Arel::Nodes::NamedFunction.new("COALESCE", [
          User.arel_table["name"],
          User.arel_table["email"],
        ]).asc
    end

    before do
      use_case.execute
    end

    it "calls the users gateway" do
      expect(gateway).to have_received(:fetch)
    end

    it "calls order on the collection of users" do
      expect(user_collection).to have_received(:order).with(valid_order_query)
    end
  end

  context "when ordering a collection of users" do
    let(:user_collection) { User.all }
    let!(:user_1) { create(:user, name: "Aardvark") }
    let!(:user_2) { create(:user, name: "Zed") }
    let!(:user_3) { create(:user, name: nil, email: "batman@batcave.com") }

    it "orders the users by name and email" do
      expect(use_case.execute).to eq([user_1, user_3, user_2])
    end
  end
end
