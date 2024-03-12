class NominationsController < ApplicationController
  def create
    name = params[:nominated_user_name]
    email = params[:nominated_user_email]
    nominated_by = params[:current_user_name]

    if name.present? && email.present?
      token = generate_token

      if @nomination.nil?
        @nomination = build_nomination(name, email, token)
      else
        @nomination.update!(
          nominated_user_name: name,
          nominated_user_email: email,
          nomination_token: token,
        )
      end

      if @nomination.save
        flash[:notice] = "Email request sent successfully."
        send_nomination_email(name, email, nominated_by, token)
        redirect_to what_happens_next_mous_path
      else
        flash[:alert] = "Error creating nomination."
        render "mous/nominate_user"
      end
    else
      flash[:alert] = "Please fill in both name and email fields."
      render "mous/nominate_user"
    end
  end

private

  def build_nomination(name, email, token)
    Nomination.new(
      nominated_user_name: name,
      nominated_user_email: email,
      nomination_token: token,
      organisation_id: current_organisation.id,
    )
  end

  def generate_token
    token = Devise.friendly_token[0, 20]
    current_organisation.nomination&.update!(nomination_token: token)
    token
  end

  def send_nomination_email(name, email, nominated_by, token)
    AuthenticationMailer.nomination_instructions(
      name,
      email,
      nominated_by,
      current_organisation.name,
      token,
    ).deliver_now
  end
end
