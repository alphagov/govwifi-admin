class SettingsController < ApplicationController
  def index
    @team_members = current_user.organisation.users
  end
end
