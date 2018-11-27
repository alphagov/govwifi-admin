module UseCases
  module Administrator
    class ValidateLogSearchQuery
      def execute(params)
        { success: success?(params) }
      end

    private

      def success?(params)
        valid_username?(params.fetch(:username)) || valid_ip?(params.fetch(:ip))
      end

      def valid_username?(username)
        username.strip unless username.nil?
        username.present? && username.length > 4
      end

      def valid_ip?(ip)
        UseCases::Administrator::CheckIfValidIp.new.execute(ip).fetch(:success)
      end
    end
  end
end
