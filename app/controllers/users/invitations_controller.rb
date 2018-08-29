class Users::InvitationsController < Devise::InvitationsController
  before_action :add_organisation_to_params, only: :create

private

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id)
  end
end
