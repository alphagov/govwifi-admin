class Admin::ManageUsersController < AdminController
  def index
    @all_unconfirmed_users = User.where(confirmed_at: nil)
  end

  def destroy
    user = User.find_by(id: params.fetch(:id))
    user.destroy
    redirect_to admin_manage_users_path, notice: "Unconfirmed user has been removed"
  end
end
