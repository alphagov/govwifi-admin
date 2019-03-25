module Gateways
  class Sessions
    MAXIMUM_RESULTS_COUNT = 500

    def initialize(ip_filter:)
      @ip_filter = ip_filter
    end

    def search(username: nil, ips: nil)
      results = if ip_filter
                  Session
                    .where(siteIP: ip_filter)
                    .where('start >= ?', 2.weeks.ago)
                    .order(start: :desc)
                    .limit(MAXIMUM_RESULTS_COUNT)
                else
                  Session
                    .where('start >= ?', 2.weeks.ago)
                    .order(start: :desc)
                    .limit(MAXIMUM_RESULTS_COUNT)
                end

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

  private

    attr_reader :ip_filter
  end
end
