class SuperAdmin::NeoController < SuperAdminController
  def dashboard; end

protected

  def current_organisation; end

  def sidebar
    :super_admin
  end
end
