module Gateways
  class UniqueConnections
    def initialize(ips:)
      @organisation_ips = ips
    end

    def unique_user_count(date_range: nil)
      return Session.where(siteIP: organisation_ips).where('start >= ?', date_range).where(success: true).distinct.count(:username) if date_range.present?

      Session.where(siteIP: organisation_ips).where(success: true).distinct.count(:username)
    end

  private

    attr_reader :organisation_ips
  end
end
