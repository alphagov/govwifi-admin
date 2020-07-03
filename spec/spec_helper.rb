if ENV["COVERAGE"]
  require "simplecov"
  require "simplecov-console"

  SimpleCov.start "rails"
  SimpleCov.minimum_coverage 100

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
  ])
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  Dir["./spec/features/support/*.rb"].sort.each { |f| require f }

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do
    FactoryBot.reload
    ActionMailer::Base.deliveries.clear

    stub_request(:get, "https://government-organisation.register.gov.uk/records.json?page-size=5000")
     .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/gov_orgs_payload.json")))

    stub_request(:get, "https://local-authority-eng.register.gov.uk/records.json?page-size=5000")
      .to_return(status: 200, body: File.read(Rails.root.join("spec/fixtures/local_auths_payload.json")))
  end

  config.around do |example|
    original_s3_aws_config = Rails.application.config.s3_aws_config
    begin
      example.run
    ensure
      Rails.application.config.s3_aws_config = original_s3_aws_config
    end
  end
end
