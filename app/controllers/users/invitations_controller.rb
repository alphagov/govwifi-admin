class Users::InvitationsController < Devise::InvitationsController
  before_action :authorise_manage_team, only: %i(create new)
  before_action :delete_original_invite, if: :resending_invite?, only: :create
  before_action :add_organisation_to_params, :validate_invited_user, only: :create

private

  def delete_original_invite
    User.find_by(email: invite_params[:email]).destroy!
  end

  def resending_invite?
    !!params[:resend]
  end

  def after_invite_path_for(_resource)
    team_members_path
  end

  def add_organisation_to_params
    params[:user][:organisation_id] = current_user.organisation_id
  end

  def validate_invited_user
    return_user_to_invite_page if user_is_invalid?
  end

  def user_is_invalid?
    @user = User.new(invite_params)
    return !invited_user_not_confirmed? if invited_user_already_exists? && invited_user_not_confirmed?

    !@user.validate
  end

  def return_user_to_invite_page
    render :new, resource: @user
  end

  def invited_user_already_exists?
    !!User.find_by(email: invite_params[:email])
  end

  def invited_user_not_confirmed?
    User.find_by(email: invite_params[:email]).confirmed_at.nil?
  end

  # Overrides https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L105
  def invite_params
    params.require(:user).permit(:email, :organisation_id, permission_attributes: %i(
      can_manage_team
      can_manage_locations
    ))
  end

  def authorise_manage_team
    redirect_to(root_path) unless current_user.can_manage_team?
  end

  def invite_resource(&block)
    @user = User.find_by(email: invite_params[:email])
    # @user is an instance or nil
    if @user.nil?
      # invite! class method returns invitable var, which is a User instance
      resource_class.invite!(invite_params, current_inviter, &block)
    elsif @user.confirmed_at.nil? && @user.email != current_user.email
      # invite! instance method returns a Mail::Message instance
      @user.invite!(current_user)
      @user.update_attributes(invite_params)
      # return the user instance to match expected return type
      @user
    end
  end
end
