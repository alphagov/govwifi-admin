class Users::ConfirmationsController < Devise::ConfirmationsController
  # This controller overrides the Devise:ConfirmationsController (part of Devise gem)
  # in order to set user passwords after they have confirmed their email. This is
  # based largely on recommendations here: 'https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation'
  before_action :set_resource, only: %i[update show]
  before_action :fetch_organisations_from_register, only: %i[update show]
  after_action :publish_organisation_names, only: :update

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
    token = params[:confirmation_token] || params.dig(:user, :confirmation_token)
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
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  def user_params
    params.require(:user).permit(:name, :password, organisation_attributes: %i[name service_email])
  end

private

  def fetch_organisations_from_register
    @register_organisations = Organisation.fetch_organisations_from_register
  end

  def publish_organisation_names
    UseCases::Administrator::PublishOrganisationNames.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_ORGANISATION_WHITELIST_BUCKET'),
        key: ENV.fetch('S3_ORGANISATION_WHITELIST_OBJECT_KEY')
      ),
      source_gateway: Gateways::OrganisationNames.new,
      presenter: UseCases::Administrator::FormatOrganisationNames.new
    ).execute
  end
end
