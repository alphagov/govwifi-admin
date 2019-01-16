module Gateways
  class UniqueConnections
    def initialize(ips:)
      @organisation_ips = ips
    end

    def unique_user_count(date_range: nil)
      if date_range.present?
        Session.where(siteIP: organisation_ips).where('start >= ?', date_range).where(success: true).distinct.count(:username)
      else
        Session.where(siteIP: organisation_ips).where(success: true).distinct.count(:username)
      end
    end

  private

    attr_reader :organisation_ips
  end
end
