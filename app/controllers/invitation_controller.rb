class InvitationController < ApplicationController
  def show_options; end

  def choose_option
    action = params[:chosen_action]
    if action == "administrator"
      update_permission_level("administrator")
    elsif action == "manage_locations"
      update_permission_level("manage_locations")
    elsif action == "view_only"
      update_permission_level("view_only")
    else
      render :show_options, alert: "Please choose a valid permission level.", status: :unprocessable_entity
    end
  end

  def new
    @permission_level = PermissionLevel.new
  end

  def create
    @permission_level = PermissionLevel.new(permissionLevel_params)
    if @permission_level.invalid?
      render :new
    else
      old_nomination = current_organisation.nomination
      old_nomination&.destroy!
      permission_level = @permission_level.save!(permission_level: current_organisation, user: current_user)
      send_invitation_email(permission_level)
      redirect_to settings_path, notice: "#{current_organisation.name} has been sent an invitation"
    end
  end

private

  def token
    params[:token] || params.dig(:permission_level, :token)
  end

  def permission_level_params
    params.require(:permission_level).permit(:email_address, :permission_level)
  end

  def send_thank_you_email(mou)
    GovWifiMailer.thank_you_for_signing_the_mou(
      mou.name,
      mou.email_address,
      mou.organisation.name,
      mou.formatted_date,
    ).deliver_now
  end
end
