class SuperAdmin::NeoController < SuperAdminController
  def dashboard; end

protected

  def sidebar
    :super_admin
  end
end
