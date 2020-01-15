config = File.read(Rails.root.join("config/database.yml"))
WIFI_USER_DB = YAML
                 .safe_load(ERB.new(config).result, aliases: true)
                 .fetch("wifi_user")
