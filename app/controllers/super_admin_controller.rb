class SuperAdminController < ApplicationController
  before_action :authorise_admin

  def authorise_admin
    redirect_to root_path unless super_admin?
  end

protected

  def sidebar
    if current_organisation&.super_admin?
      :super_org
    else
      super
    end
  end
end
