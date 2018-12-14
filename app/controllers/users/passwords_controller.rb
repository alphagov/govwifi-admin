class Users::PasswordsController < Devise::PasswordsController
  append_before_action :validate_user_is_confirmed, only: :create
  append_before_action :assert_reset_token_passed, only: :edit

protected

  def validate_user_is_confirmed
    current_user_details = params[:user]
    user_email = current_user_details[:email]
    unless User.find_by(email: user_email).nil? || User.find_by(email: user_email).confirmed?
      set_flash_message(:alert, :unconfirmed)
      redirect_to new_user_confirmation_path
    end
  end
end
