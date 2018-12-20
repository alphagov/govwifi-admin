class HelpController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @support_form = SupportForm.new(support_form_params)

    if @support_form.valid?
      redirect_user
    else
      render @support_form.choice
    end

    template_id = GOV_NOTIFY_CONFIG['help_email']['template_id']

    UseCases::Administrator::SendHelpEmail.new(
      notifications_gateway: EmailGateway.new
    ).execute(
      email: GOV_NOTIFY_CONFIG['support_email'],
      sender_email: sender_email,
      name: params[:support_form][:name] || current_user&.name,
      organisation: sender_organisation_name,
      details: params[:support_form][:details],
      phone: params[:phone] || "",
      subject: params[:subject] || "",
      template_id: template_id
    )
  end

  def new
    case params[:choice]
    when "signing_up"
      redirect_to signing_up_new_help_path
    when "existing_account"
      redirect_to existing_account_new_help_path
    when "feedback"
      redirect_to feedback_new_help_path
    end
  end

  def signing_up
    @support_form = SupportForm.new
    @support_form.choice = :signing_up
  end

  def existing_account
    @support_form = SupportForm.new
    @support_form.choice = :existing_account
  end

  def feedback
    @support_form = SupportForm.new
    @support_form.choice = :feedback
  end

  def signed_in
    @support_form = SupportForm.new
    @support_form.choice = :signed_in
  end

private

  def support_form_params
    params.require(:support_form).permit(:name, :details, :email, :organisation, :choice)
  end

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
