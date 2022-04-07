module Gateways
  class Sessions
    MAXIMUM_RESULTS_COUNT = 500

    def self.search(username: nil, ips: nil, success: nil)
      new.search(username:, ips:, success:)
    end

    def search(username: nil, ips: nil, success: nil)
      results = Session
                  .where("start >= ?", 2.weeks.ago)
                  .order(start: :desc)
                  .limit(MAXIMUM_RESULTS_COUNT)

      results = results.where(username:) unless username.nil?
      results = results.where(siteIP: ips) unless ips.nil?
      results = results.where(success:) unless success.nil?
      results
    end
  end
end
