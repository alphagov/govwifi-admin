class SuperAdminController < ApplicationController
  skip_before_action :redirect_user_with_no_organisation
  before_action :authorise_admin

  def authorise_admin
    redirect_to root_path unless super_admin?
  end
end
