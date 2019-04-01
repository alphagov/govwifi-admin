class HomeController < ApplicationController
  def index
    return redirect_to admin_organisations_path if current_user.super_admin?

    redirect_to(current_organisation.ips.empty? ? initial_setup_instructions_path : overview_index_path)
  end
end
