# frozen_string_literal: true

module Deploy
  def self.production?
    ENV["DEPLOY_ENV"] == "production"
  end

  def self.env
    ENV["DEPLOY_ENV"] || "production"
  end

  def self.env=(env)
    ENV["DEPLOY_ENV"] = env
  end
end
