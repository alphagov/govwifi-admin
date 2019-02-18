module UseCases
  module Administrator
    class CreateSignupWhitelist
      NOOP_REGEX = '^$'.freeze

      def execute(domains)
        return NOOP_REGEX if domains.empty?

        '^.*@' + literal_dot(domains_list(domains) + '$')
      end

    private

      def domains_list(domains)
        "(#{domains.join('|')})"
      end

      def literal_dot(whitelist)
        whitelist.gsub('.', '\.')
      end
    end
  end
end
