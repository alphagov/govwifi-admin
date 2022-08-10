Rails.application.config.after_initialize do
  ActiveStorage::Blobs::RedirectController.include(GovWifiAuthenticatable)
  ActiveStorage::Blobs::RedirectController.include(AbleToReadMou)
end
