class ReadReplicaBase < ActiveRecord::Base
  self.abstract_class = true

  CONFIG = {
    adapter: 'mysql2',
    encoding: 'utf8',
    host: ENV.fetch('RR_DB_HOST'),
    username: ENV.fetch('RR_DB_USER'),
    password: ENV.fetch('RR_DB_PASS'),
    database: ENV.fetch('RR_DB_NAME')
  }.freeze

  establish_connection CONFIG
end
