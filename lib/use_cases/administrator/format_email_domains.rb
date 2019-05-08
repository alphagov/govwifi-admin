module UseCases
  module Administrator
    class FormatEmailDomainsNames
      def execute(email_domains)
        return "" if email_domains.empty?

        email_domains_list(email_domains)
      end

    private

      def email_domains_list(email_domains)
        "- #{email_domains.join('\n- ')}"
      end
    end
  end
end
