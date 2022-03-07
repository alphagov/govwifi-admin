class SuperAdminController < ApplicationController
  before_action :authorise_admin

  def authorise_admin
    redirect_to root_path unless super_admin?
  end

protected

  def sidebar
    :super_org
  end

  def subnav
    :neo
  end
end
