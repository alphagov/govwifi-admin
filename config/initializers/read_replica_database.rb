config = File.read(File.join( Rails.root, 'config', 'database.yml'))
READ_REPLICA_DB = YAML.load(ERB.new(config).result).fetch('read_replica')
