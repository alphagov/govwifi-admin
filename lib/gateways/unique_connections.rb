module Gateways
  class UniqueConnections
    def initialize(ips:)
      @organisation_ips = ips
    end

    def unique_user_count(date_range: nil)
      query = Session
        .where(success: true)
        .distinct
        .where(siteIP: organisation_ips)

      query = query.where('start >= ?', date_range) if date_range.present?

      query.count(:username)
    end

  private

    attr_reader :organisation_ips
  end
end
