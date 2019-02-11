module Gateways
  class UniqueConnections
    def initialize(ips:)
      @organisation_ips = ips
    end

    def unique_user_count
      Session
        .where(success: true)
        .distinct
        .where(siteIP: organisation_ips)
        .where('start >= ?', 1.day.ago)
        .count(:username)
    end

  private

    attr_reader :organisation_ips
  end
end
