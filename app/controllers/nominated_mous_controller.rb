class NominatedMousController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_token
  before_action :set_nomination, only: %i[new create]

  def new
    @token = token_from_params
    @mou = Mou.new
  end

  def create
    @token = token_from_params
    nominee_params = mou_params.merge(organisation: @organisation,
                                      version: Mou.latest_version)
    @mou = Mou.new(nominee_params)
    if @mou.save
      @nomination.destroy!
      send_thank_you_email(@mou)
      redirect_to confirm_nominated_mous_path(organisation_name: @organisation.name), success: "MOU signed successfully."
    else
      render :new
    end
  end

  def confirm
    @organisation_name = params[:organisation_name]
  end

private

  def check_token
    redirect_to root_path, error: "Invalid token." unless Nomination.exists?(token: token_from_params)
  end

  def token_from_params
    params[:token] || params.dig(:mou, :token)
  end

  def set_nomination
    @nomination = Nomination.find_by(token: token_from_params) if token_from_params.present?
    @organisation = @nomination&.organisation
  end

  def mou_params
    params.require(:mou).permit(:name, :email_address, :job_role, :signed)
  end

  def send_thank_you_email(mou)
    AuthenticationMailer.thank_you_for_signing_the_mou(
      mou.name,
      mou.email_address,
      mou.organisation.name,
      mou.created_at,
    ).deliver_now
  end
end
