module UseCases
  module Administrator
    class FormatEmailDomainsList
      def execute(email_domains)
        StringIO.new(email_domains.to_yaml)
      end
    end
  end
end
