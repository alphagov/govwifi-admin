class SuperAdmin::NeoController < SuperAdminController
  def dashboard
    @manage_link =
      if current_user.new_super_admin?
        ips_path
      else
        root_path
      end
  end

protected

  def subnav
    :neo
  end

  def current_organisation; end

  def redirect_user_with_no_organisation; end

  def sidebar
    :super_admin
  end
end
