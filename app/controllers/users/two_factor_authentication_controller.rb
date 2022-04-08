class Users::TwoFactorAuthenticationController < Devise::TwoFactorAuthenticationController
  before_action :validate_can_manage_team, only: %i[edit destroy]
  skip_before_action :redirect_user_with_no_organisation

  def edit
    @user = User.find(params.fetch(:id))
  end

  def destroy
    @user = User.find(params.fetch(:id))

    @user.reset_2fa!

    redirect_path = if current_user.is_super_admin?
                      super_admin_organisations_path
                    else
                      memberships_path
                    end

    redirect_to redirect_path, notice: "Two factor authentication has been reset"
  end

  def validate_can_manage_team
    user = User.find(params.fetch(:id))

    redirect_to root_path unless current_user.can_manage_other_user_for_org?(user, current_organisation)
  end

  def sidebar
    :empty
  end

  def subnav
    :empty
  end
end
