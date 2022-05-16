Rails.application.config.content_security_policy do |policy|
  policy.script_src :self, "https://www.googletagmanager.com", "https://www.google-analytics.com"
end
