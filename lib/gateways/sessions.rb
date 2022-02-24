module Gateways
  class Sessions
    MAXIMUM_RESULTS_COUNT = 500

    def initialize(ip_filter:)
      @ip_filter = ip_filter
    end

    def search(username: nil, ips: nil, success: nil)
      results = Session
                  .where("start >= ?", 2.weeks.ago)
                  .order(start: :desc)
                  .limit(MAXIMUM_RESULTS_COUNT)

      results = results.where(siteIP: ip_filter) if ip_filter
      results = results.where(username:) if username.present?
      results = results.where(siteIP: ips) if ips.present?
      results = results.where(success:) if success.present?

      results.map do |log|
        {
          username: log.username,
          ap: log.ap,
          mac: log.mac,
          site_ip: log.siteIP,
          start: log.start,
          success: log.success,
          task_id: log.task_id,
        }
      end
    end

  private

    attr_reader :ip_filter
  end
end
