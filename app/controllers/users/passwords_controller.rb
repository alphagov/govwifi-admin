class Users::PasswordsController < Devise::PasswordsController
  before_action :validate_user_is_confirmed, only: :edit

protected

  def validate_user_is_confirmed
    unless @user.confirmed?
      redirect_to new_user_session_path
      flash[:notice] = "Please confirm your account first"
    end
  end
end
