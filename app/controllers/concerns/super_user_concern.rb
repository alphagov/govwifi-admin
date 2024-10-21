module SuperUserConcern
  extend ActiveSupport::Concern
  included do
    skip_before_action :redirect_user_with_no_organisation
    before_action :authorise_admin
  end

  def authorise_admin
    redirect_to root_path unless super_admin?
  end
end
