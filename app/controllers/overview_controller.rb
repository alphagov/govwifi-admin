class OverviewController < ApplicationController
  def index
    @ips = current_organisation.ips
    @locations = current_organisation.locations
    @team_members = current_organisation.users
  end
end
