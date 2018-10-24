class ReadReplicaBase < ActiveRecord::Base
  self.abstract_class = true

  establish_connection READ_REPLICA_DB
end
