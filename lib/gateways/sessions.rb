module Gateways
  class Sessions
    def initialize(ips:)
      @ips = ips
    end

    def search(username:, ip: nil)
      query = { username: username }
      query[:siteIP] = ip unless ip.nil?

      results = Session.where(query).where(
        'start >= ? and siteIP IN (?)', 2.weeks.ago, ips
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
