class Admin::ManageUsersController < AdminController
  def index
    @all_unconfirmed_users = User.where(confirmed_at: nil)
  end
end
