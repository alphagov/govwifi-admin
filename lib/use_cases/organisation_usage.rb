class UseCases::OrganisationUsage
  def self.fetch_stats
    {
      metric: "time_to_first_ip",
      median: Gateways::Sessions.organisation_usage_stats,
      date: Time.zone.today,
    }
  end
end
