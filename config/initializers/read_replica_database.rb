config = File.read(Rails.root.join("config/database.yml"))
READ_REPLICA_DB = YAML.load(ERB.new(config).result, aliases: true).fetch("read_replica")
