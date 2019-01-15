module Gateways
  class Sessions
    MAXIMUM_RESULTS_COUNT = 500

    def initialize(ips:)
      @organisation_ips = ips
    end

    def search(username: nil, ips: nil)
      results = Session
        .where(siteIP: organisation_ips)
        .where('start >= ?', 2.weeks.ago)
        .order(start: :desc)
        .limit(MAXIMUM_RESULTS_COUNT)

      results = results.where(username: username) if username.present?
      results = results.where(siteIP: ips) if ips.present?

      results.map do |log|
        {
          username: log.username,
          ap: log.ap,
          mac: log.mac,
          site_ip: log.siteIP,
          start: log.start,
          success: log.success
        }
      end
    end

    def count_distinct_users
      Session.where(siteIP: organisation_ips).where('start >= ?', 1.day.ago).where(success: true).distinct.count(:username)
    end

  private

    attr_reader :organisation_ips
  end
end
