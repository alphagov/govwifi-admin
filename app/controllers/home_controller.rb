class HomeController < ApplicationController
  def index
    if super_admin?
      redirect_to super_admin_organisations_path
    elsif new_super_admin?
      redirect_to super_admin_neo_dashboard_path
    else
      redirect_to(current_organisation.ips.empty? ? new_organisation_setup_instructions_path : overview_index_path)
    end
  end
end
