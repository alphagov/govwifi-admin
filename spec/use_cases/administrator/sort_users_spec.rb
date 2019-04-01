describe UseCases::Administrator::SortUsers do
  subject(:use_case) { described_class.new(users_gateway: gateway_spy) }

  let(:user_collection_spy) { instance_spy('User::ActiveRecord_Relation', order: nil) }
  let(:gateway_spy) do
    instance_spy('Gateways::OrganisationUsers', fetch: user_collection_spy)
  end
  let(:valid_order_query) do
    Arel::Nodes::NamedFunction.new("COALESCE", [
        User.arel_table['name'],
        User.arel_table['email']
      ]).asc
  end

  before do
    use_case.execute
  end

  it 'calls the users gateway' do
    expect(gateway_spy).to have_received(:fetch)
  end

  it 'calls order on the collection of users' do
    expect(user_collection_spy).to have_received(:order).with(valid_order_query)
  end
end
