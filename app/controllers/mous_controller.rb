class MousController < ApplicationController
  def show_options; end

  def choose_option
    action = params[:chosen_action]
    if action == "sign_mou"
      redirect_to new_mou_path
    elsif action == "nominate_user"
      redirect_to new_nomination_path
    else
      render :show_options, error: "Please choose an option to proceed."
    end
  end

  def new
    @mou = Mou.new
  end

  def create
    @mou = Mou.new(mou_params)
    @mou.organisation = current_organisation
    if @mou.save
      send_thank_you_email(@mou)
      redirect_to settings_path, notice: "#{current_organisation.name} has accepted the MOU for GovWifi"
    else
      render "sign_mou"
    end
  end

private
  def token
    params[:token] || params.dig(:mou, :token)
  end

  def mou_params
    params.require(:mou).permit(:name, :email_address, :job_role, :signed, :token)
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
