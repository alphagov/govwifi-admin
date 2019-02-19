module Gateways
  class AuthorisedEmailDomains
    def fetch_domains
      AuthorisedEmailDomain.pluck(:name)
    end
  end
end
