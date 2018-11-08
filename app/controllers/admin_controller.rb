class AdminController < ApplicationController
  before_action :authorise_admin

  def authorise_admin
    redirect_to root_path unless current_user.admin?
  end
end
