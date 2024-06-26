# frozen_string_literal: true

module Deploy
  def self.production?
    ENV["APP_ENV"] == "production"
  end

  def self.env
    ENV["APP_ENV"] || "production"
  end

  def self.env=(env)
    ENV["APP_ENV"] = env
  end
end
