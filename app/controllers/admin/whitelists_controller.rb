class Admin::WhitelistsController < AdminController
  def new
    @whitelist = Whitelist.new
    @organisation_names = Organisation.fetch_organisations_from_register
    validate_organisation_name if organisation_name_needs_validation?
    validate_email_domain if email_domain_needs_validation?
  end

  def create
    @whitelist = Whitelist.new(
      organisation_name: whitelist_params[:organisation_name],
      email_domain: whitelist_params[:email_domain]
    )
    if @whitelist.save
      publish_email_domains_regex
      publish_email_domains_list

      redirect_to new_admin_whitelist_path,
                  notice: "Organisation has been whitelisted"
    else
      redirect_to new_admin_whitelist_path(step: "fourth"),
                  notice: 'There was an error, please try again'
    end
  end

private

  def publish_email_domains_regex
    UseCases::Administrator::PublishSignupWhitelist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_SIGNUP_WHITELIST_BUCKET'),
        key: ENV.fetch('S3_SIGNUP_WHITELIST_OBJECT_KEY')
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsRegex.new
    ).execute
  end

  def publish_email_domains_list
    UseCases::Administrator::PublishSignupWhitelist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_PRODUCT_PAGE_DATA_BUCKET'),
        key: ENV.fetch('S3_EMAIL_DOMAINS_OBJECT_KEY')
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsList.new
    ).execute
  end

  def organisation_name_needs_validation?
    organisation_name_submitted? && organisation_name_not_yet_validated?
  end

  def organisation_name_submitted?
    params.dig(:whitelist, :organisation_name).present?
  end

  def organisation_name_not_yet_validated?
    !!!whitelist_params.dig(:organisation_name_valid)
  end

  def validate_organisation_name
    @organisation_name = CustomOrganisationName.new(name: whitelist_params.dig(:organisation_name))
    if @organisation_name.invalid?
      send_user_back_to_organisation_name_form
    else
      mark_organisation_name_as_validated
    end
  end

  def send_user_back_to_organisation_name_form
    params[:whitelist][:step] = "fourth"
  end

  def mark_organisation_name_as_validated
    params[:whitelist][:organisation_name_valid] = true
  end

  def email_domain_needs_validation?
    params.dig(:whitelist, :email_domain).present?
  end

  def validate_email_domain
    @email_domain = AuthorisedEmailDomain.new(name: whitelist_params.dig(:email_domain))
    if @email_domain.invalid?
      send_user_back_to_email_domain_form
    end
  end

  def send_user_back_to_email_domain_form
    params[:whitelist][:step] = "fifth"
  end

  def whitelist_params
    params.require(:whitelist).permit(:email_domain, :organisation_name, :organisation_name_valid)
  end
end
