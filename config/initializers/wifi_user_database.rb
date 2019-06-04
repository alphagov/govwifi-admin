config = File.read(File.join(Rails.root, 'config', 'database.yml'))
# rubocop:disable Security/YAMLLoad
WIFI_USER_DB = YAML.load(ERB.new(config).result).fetch('wifi_user')
# rubocop:enable Security/YAMLLoad
