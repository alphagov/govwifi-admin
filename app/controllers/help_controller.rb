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

    unless current_user.nil?
      redirect_to root_path, notice: 'Your support request has been submitted.'
    else
      redirect_to new_user_session_path, notice: 'Your support request has been submitted.'
    end
  end

  def new

    case
    when params[:choice_id] == "1"
      redirect_to choice1_new_help_path
    when params[:choice_id] == "2"
      redirect_to choice2_new_help_path
    when params[:choice_id] == "3"
      redirect_to choice3_new_help_path
    end
  end

  def choice1; end

  def choice2; end

  def choice3; end

private

  def sender_email
    params[:sender_email] || current_user&.email || ""
  end

  def sender_organisation_name
    params[:organisation] || current_user&.name || ""
  end
end
