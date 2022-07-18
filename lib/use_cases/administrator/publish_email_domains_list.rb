module UseCases
  module Administrator
    class PublishEmailDomainsList
      def publish
        authorised_email_domains = AuthorisedEmailDomain.pluck(:name)
        Gateways::S3.new(**Gateways::S3::DOMAIN_ALLOW_LIST).write(authorised_email_domains.to_yaml)
      end
    end
  end
end
