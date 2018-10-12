module Gateways
  class Sessions
    def search(username:)
      results = Session.where('username = ? and start >= ?', username, 2.weeks.ago)

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
  end
end
