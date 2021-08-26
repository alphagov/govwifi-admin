namespace :cleanup do
  desc "Clean up orphan users"
  task orphans: :environment do
    gateway = Gateways::OrphanUsers.new

    gateway.fetch.destroy_all
  end
end
