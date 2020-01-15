class ReadReplicaBase < ApplicationRecord
  self.abstract_class = true

  establish_connection READ_REPLICA_DB
end
