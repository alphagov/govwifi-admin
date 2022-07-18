module UseCases
  module Administrator
    class PublishEmailDomainsRegex
      SIGNUP_ALLOWLIST_PREFIX_MATCHER = '^[A-Za-z0-9\_\+\.\'-]+@([a-zA-Z0-9-]+\.)*'.freeze

      def publish
        authorised_email_domains = AuthorisedEmailDomain.pluck(:name)
        regexp_to_publish = regexp(authorised_email_domains)
        Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).write(regexp_to_publish)
      end

    private

      def regexp(authorised_email_domains)
        return "^$" if authorised_email_domains.empty?

        all_domains_regexp = authorised_email_domains.map { |domain| Regexp.escape(domain) }.join("|")
        "#{SIGNUP_ALLOWLIST_PREFIX_MATCHER}(#{all_domains_regexp})$"
      end
    end
  end
end
