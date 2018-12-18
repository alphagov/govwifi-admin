class HelpController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def create
    template_id = GOV_NOTIFY_CONFIG['help_email']['template_id']

    UseCases::Administrator::SendHelpEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      email: GOV_NOTIFY_CONFIG['support_email'],
      sender_email: current_user.email,
      name: current_user.name,
      organisation: current_organisation.name,
      details: params[:details],
      phone: params[:contact_number],
      subject: params[:subject],
      template_id: template_id
    )
    redirect_to root_path, notice: 'Your support request has been submitted.'
  end

  def new
    if params[:choice_id] == "1"
      redirect_to help_choice1_path(:id)
    elsif params[:choice_id] == "2"
      redirect_to help_choice2_path(:id)
    elsif params[:choice_id] == "3"
      redirect_to help_choice3_path(:id)
    end
  end

end
