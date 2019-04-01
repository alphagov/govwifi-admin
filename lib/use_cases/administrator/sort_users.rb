module UseCases
  module Administrator
    class SortUsers
      def initialize(users_gateway:)
        @users_gateway = users_gateway
      end

      def execute
        unsorted_users = @users_gateway.fetch
        unsorted_users.order(build_order_query)
      end

    private

      def build_order_query
        Arel::Nodes::NamedFunction.new("COALESCE", [
          User.arel_table['name'],
          User.arel_table['email']
        ]).asc
      end
    end
  end
end
