SITE_CONFIG = YAML.load_file(
  Rails.root.join('config/site.yml')
)[Rails.env]
