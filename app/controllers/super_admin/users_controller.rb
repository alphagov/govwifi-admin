class SuperAdmin::UsersController < SuperAdminController
  helper_method :super_admins

  def new
    @user = User.new
  end

  def index
    respond_to do |format|
      format.csv { send_data User.admin_usage_csv, filename: "admin_usage.csv" }
      format.html { render :index }
    end
  end

  def create
    @user = User.find_by!(email: params.require(:user)[:email])

    if @user.is_super_admin?
      @user.errors[:email] << "User is already a super admin"

      render :new
    else
      @user.update!(is_super_admin: true)

      flash[:notice] = "#{@user.name} is now a super admin"

      render :index
    end
  rescue ActiveRecord::RecordNotFound
    @user = User.new
    @user.errors[:email] << "No user with this email address"

    render :new
  end

  def confirm_remove
    @user = User.find(params.fetch(:user_id))

    if !@user.is_super_admin?
      flash[:alert] = "#{@user.name} is not a super admin"

      redirect_to super_admin_users_path
    else
      render :confirm_remove
    end
  end

  def remove
    user = User.find(params.fetch(:user_id))

    if !user.is_super_admin?
      flash[:alert] = "#{user.name} is not a super admin"
    elsif current_user.email == user.email
      flash[:alert] = "Can't remove super admin privileges from yourself"
    else
      user.update!(is_super_admin: false)

      flash[:notice] = "#{user.name} (#{user.email}) is no longer a super admin"
    end

    redirect_to super_admin_users_path
  end

  def super_admins
    User.where(is_super_admin: true)
  end
end
