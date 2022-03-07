class HomeController < ApplicationController
  def index
    destination =
      if !current_organisation && current_user.is_super_admin?
        super_admin_organisations_path
      elsif current_organisation.ips.empty?
        new_organisation_settings_path
      else
        ips_path
      end

    redirect_to destination
  end
end
