require 'simplecov'

SimpleCov.start

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

    stub_request(:get, 'https://government-organisation.register.gov.uk/records.json').
     to_return(status: 200, body: File.read("#{Rails.root}/spec/fixtures/registers_payload.json"))
  end

  ENV['AUTHORISED_EMAIL_DOMAINS_REGEX'] = '.*gov\.uk'
end
