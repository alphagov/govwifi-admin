class HelpController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def create
    template_id = GOV_NOTIFY_CONFIG['help_email']['template_id']

    UseCases::Administrator::SendHelpEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      email: GOV_NOTIFY_CONFIG['support_email'],
      sender_email: sender_email,
      name: params[:name] || current_user&.name,
      organisation: sender_organisation_name,
      details: params[:details],
      phone: params[:phone] || "",
      subject: params[:subject] || "",
      template_id: template_id
    )
    redirect_user
  end

  def new
    case params[:choice_id]
    when "1"
      redirect_to choice1_new_help_path
    when "2"
      redirect_to choice2_new_help_path
    when "3"
      redirect_to choice3_new_help_path
    end
  end

  def choice1; end

  def choice2; end

  def choice3; end

private

  def redirect_user
    if current_user.nil?
      redirect_to new_user_session_path, notice: 'Your support request has been submitted.'
    else
      redirect_to root_path, notice: 'Your support request has been submitted.'
    end
  end

  def sender_email
    params[:sender_email] || current_user&.email || ""
  end

  def sender_organisation_name
    params[:organisation] || current_user&.name || ""
  end
end
