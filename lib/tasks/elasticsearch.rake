require "logger"
logger = Logger.new($stdout)

namespace :elasticsearch do
  desc "Publishing metrics to ElasticSearch"
  task publish_metrics: :environment do
    logger.info("Fetching and uploading metrics ...")

    Gateways::Elasticsearch.new("govwifi-metrics").write("organisation_usage_stats-#{Time.zone.today}", UseCases::OrganisationUsage.fetch_stats)

    logger.info("Done.")
  end
end
