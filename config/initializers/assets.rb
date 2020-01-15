# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

Rails.application.config.assets.precompile += %w(
  govuk-logotype-crown.png
  application_ie8.css
  html5shiv.js
  accessible-autocomplete.min.js
  accessible-autocomplete.min.css
  tick.svg
  cross.svg
)

Rails.application.config.assets.paths += [
  Rails.root.join("node_modules/govuk-frontend/govuk/assets/images"),
  Rails.root.join("node_modules/govuk-frontend/govuk/assets/fonts"),
  Rails.root.join("node_modules/govuk-frontend/govuk"),
  Rails.root.join("node_modules/html5shiv/dist"),
]
