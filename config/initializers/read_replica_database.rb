config = File.read(Rails.root.join("config/database.yml"))
# rubocop:disable Security/YAMLLoad
READ_REPLICA_DB = YAML.load(ERB.new(config).result, aliases: true).fetch("read_replica")
# rubocop:enable Security/YAMLLoad
