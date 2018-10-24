module Gateways
  class Sessions
    def initialize(ips:)
      @ips = ips
    end

    def search(username: nil, ip: nil)
      query = username.present? ? { username: username } : { siteIp: ip }

      results = Session.where(query).where(
        'start >= ? and siteIP IN (?)', 2.weeks.ago, ips
      ).order('start DESC').limit(500)

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

  private

    attr_reader :ips
  end
end
