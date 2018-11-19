class Ips::RemoveController < ApplicationController
  def show
    @ip = Ip.find(params[:ip_id])
  end
end
