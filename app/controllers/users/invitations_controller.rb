class Users::InvitationsController < Devise::InvitationsController
  before_action :add_organisation_to_params, :validate_invited_user, only: :create

private

  def validate_invited_user
    return if User.find_by(email: invite_params[:email])
    @user = User.new(invite_params)
    render :new, resource: @user unless @user.validate
  end

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id)
  end
end
