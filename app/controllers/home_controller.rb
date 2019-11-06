class HomeController < ApplicationController
  def index
    destination =
      if current_user.super_admin?
        if current_organisation.nil?
          super_admin_neo_dashboard_path
        elsif current_organisation.super_admin?
          super_admin_organisations_path
        else
          overview_index_path
        end
      elsif current_organisation.ips.empty?
        new_organisation_setup_instructions_path
      else
        overview_index_path
      end

    redirect_to destination
  end
end
