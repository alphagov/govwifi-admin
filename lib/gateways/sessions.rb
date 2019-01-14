module Gateways
  class Sessions
    MAXIMUM_RESULTS_COUNT = 500

    def initialize(ips:)
      @ips = ips
    end

    def search(username: nil, ip: nil)
      query = username.present? ? { username: username } : { siteIp: ip }

      results = Session.where(query).where(
        'start >= ? and siteIP IN (?)', 2.weeks.ago, ips
      ).order('start DESC').limit(MAXIMUM_RESULTS_COUNT)

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

    def count_distinct_users(ips:)
      Session.where(siteIP: ips).where(success: true).count
    end

  private

    attr_reader :ips
  end
end
