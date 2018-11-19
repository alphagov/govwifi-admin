class Ips::RemoveController < ApplicationController
  before_action :authorise_manage_locations, only: %i(show)

  def show
    @ip = Ip.find(params[:ip_id])
  end
end
