class Users::ConfirmationsController < Devise::ConfirmationsController
  # This controller overrides the Devise:ConfirmationsController (part of Devise gem)
  # in order to set user passwords after they have confirmed their email. This is
  # based largely on recommendations here: 'https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation'
  before_action :set_resource, only: %i[update show]

  def update
    with_unconfirmed_confirmable do
      if @confirmable.update(user_params)
        confirm_user
      else
        render_show_page
      end
    end
  end

  def show
    with_unconfirmed_confirmable do
      render_show_page
    end
    if @confirmable.errors.present?
      render_new_page
    end
  end

  def pending; end

protected

  def set_resource
    token = params[:confirmation_token] || params[:user][:confirmation_token]
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, token)
    self.resource = @confirmable
  end

  def with_unconfirmed_confirmable
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed { yield }
    end
  end

  def render_show_page
    render 'users/confirmations/show', confirmation_token: @original_token
  end

  def render_new_page
    render 'users/confirmations/new'
  end

  def confirm_user
    @confirmable.confirm
    notify_support_of_new_user(@confirmable)
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  def notify_support_of_new_user(user)
    UseCases::Administrator::NotifySupportOfNewUser.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      new_user_email: user.email,
      template_id: GOV_NOTIFY_CONFIG['notify_support_of_new_user']['template_id']
    )
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, organisation_attributes: %i[name service_email])
  end
end
