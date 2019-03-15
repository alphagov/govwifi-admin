class Admin::ManageUsersController < AdminController
  def index
    @all_unconfirmed_users = User.where(confirmed_at: nil)
  end

  def destroy
    user = User.find_by(id: params.fetch(:id))
    user.destroy
  end
end
