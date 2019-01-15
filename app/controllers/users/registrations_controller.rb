# frozen_string_literal: true
require 'net/http'
require 'json'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :validate_email_on_whitelist, only: :create

  def new
    @register_org_names = parse_register
    super
  end

  def parse_register
    url = "https://government-organisation.register.gov.uk/records.json?page-size=5000"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_json = JSON.parse(response)

    mapped_json = parsed_json.map { |_, v| v.dig('item',  0, 'name')}
    searched_json = mapped_json.lazy.select { |word| word.start_with?('n', 'N') }.first(5000)

  end
end

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :validate_email_on_whitelist, only: :create

protected

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    users_confirmations_pending_path(email: resource.email)
  end

  def validate_email_on_whitelist
    checker = UseCases::Administrator::CheckIfWhitelistedEmail.new
    whitelisted = checker.execute(sign_up_params[:email])[:success]
    set_user_object_with_errors && return_user_to_registration_page unless whitelisted
  end

  def set_user_object_with_errors
    @user = User.new(sign_up_params)
    @user.errors.add(:email, 'must be from a government domain')
  end

  def return_user_to_registration_page
    render :new, resource: @user
  end
end
