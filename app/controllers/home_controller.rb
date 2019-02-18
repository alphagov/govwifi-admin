class HomeController < ApplicationController
  def index
    return redirect_to admin_organisations_path if current_user.super_admin?

    return redirect_to setup_instructions_path if current_organisation.ips.empty?

    redirect_to overview_index_path
  end
end
