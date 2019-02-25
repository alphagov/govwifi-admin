module UseCases
  module Administrator
    class CreateSignupWhitelist
      NOOP_REGEX = '^$'.freeze

      def execute(domains)
        return NOOP_REGEX if domains.empty?

        '^[A-Za-z0-9\_\+\.\'-]+@([a-zA-Z0-9-]+\.)*' + domains_list(domains) + '$'
      end

    private

      def domains_list(domains)
        "(#{escaped_domains(domains).join('|')})"
      end

      def escaped_domains(domains)
        domains.map { |domain| Regexp.escape(domain) }
      end
    end
  end
end
