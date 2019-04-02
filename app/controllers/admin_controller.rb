class AdminController < ApplicationController
  before_action :authorise_admin

  def authorise_admin
    redirect_to root_path unless super_admin?
  end
end
