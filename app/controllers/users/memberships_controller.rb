class Users::MembershipsController < ApplicationController
  def create
    invitation = current_user.memberships.find_by(invitation_token: params.fetch(:token))
    invitation.confirm!

    redirect_to root_path, notice: "You have successfully joined #{invitation.organisation.name}"
  end
end
