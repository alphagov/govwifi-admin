GOV_NOTIFY_CONFIG = YAML.load_file(
  Rails.root.join("config/gov_notify.yml"),
)[Rails.env]
