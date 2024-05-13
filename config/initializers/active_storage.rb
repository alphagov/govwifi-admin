Rails.application.config.after_initialize do
  ActiveStorage::Blobs::RedirectController.include(GovWifiAuthenticatable)
end
