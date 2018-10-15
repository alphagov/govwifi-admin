module Gateways
  class Sessions
    def initialize(ips:)
      @ips = ips
    end

    def search(username:)
      results = Session.where(
        'username = ? and start >= ? and siteIP in (?)', username, 2.weeks.ago, ips.join(',')
      ).order('start DESC').limit(100)

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
