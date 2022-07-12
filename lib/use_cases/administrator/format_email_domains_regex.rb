module UseCases
  module Administrator
    class FormatEmailDomainsRegex
      NOOP_REGEX = "^$".freeze

      def execute(domains)
        return NOOP_REGEX if domains.empty?

        SIGNUP_ALLOWLIST_PREFIX_MATCHER + domains_list(domains) + "$" # rubocop:disable Style/StringConcatenation
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
