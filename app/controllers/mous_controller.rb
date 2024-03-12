class MousController < ApplicationController
  skip_before_action :authenticate_user!, only: :sign

  def new
    @mou = Mou.new
  end

  def choose_option
    action = params.dig(:mou, :action)
    if action == "sign_mou"
      @mou = Mou.new(mou_params)
      render "sign_mou"
    elsif action == "nominate_user"
      render "nominate_user"
    else
      flash[:notice] = "Please choose an option to proceed."
      render :new
    end
  end

  def sign
    @mou = Mou.new(mou_params)
    if params[:token].present?
      handle_nomination_signature
    else
      handle_regular_signature
    end
  end

private

  def handle_nomination_signature
    if @mou.save
      flash[:success] = "MOU signed successfully."
      invalidate_nomination(@mou.organisation_id)
      send_thank_you_email(@mou)
      redirect_to confirmation_of_signature_path(organisation_id: @mou.organisation_id)
    else
      flash[:alert] = @mou.errors.full_messages.join(". ").to_s
      redirect_to nominee_mou_form_path(token: params[:token])
    end
  end

  def handle_regular_signature
    if @mou.save
      flash[:success] = "MOU signed successfully."
      invalidate_nomination(@mou.organisation_id)
      send_thank_you_email(@mou)
      @mou_signed_notification = true
      redirect_to settings_path
    else
      flash[:alert] = @mou.errors.full_messages.join(". ").to_s
      render "sign_mou"
    end
  end

  def mou_params
    params.require(:mou).permit(:name, :email_address, :job_role, :signed).tap do |mou_params|
      mou_params[:user] = current_user_or_nil
      mou_params[:organisation] = find_organisation(mou_params[:organisation_id])
      mou_params[:organisation] ||= find_organisation_by_nomination_token(params[:token]) if params[:token].present?
      mou_params[:version] = mou_params[:organisation].latest_mou_version
      mou_params[:signed_date] = Time.zone.today
    end
  end

  def current_user_or_nil
    current_user || nil
  end

  def send_thank_you_email(mou)
    AuthenticationMailer.thank_you_for_signing_the_mou(
      mou.name,
      mou.email_address,
      mou.organisation.name,
      mou.signed_date,
    ).deliver_now
  end

  def find_organisation(organisation_id)
    Organisation.find_by(id: organisation_id) || current_organisation
  end

  def invalidate_nomination(organisation_id)
    nomination = Nomination.find_by(organisation_id:)
    nomination.update!(nomination_token: nil) if nomination
  end

  def find_organisation_by_nomination_token(token)
    nomination = Nomination.find_by(nomination_token: token)
    nomination&.organisation
  end
end
