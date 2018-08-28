class Users::InvitationsController < Devise::InvitationsController
  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L12
  def new
    self.resource = User.new(organisation_id: current_user.organisation_id)
    render :new
  end

private

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id)
  end
end
