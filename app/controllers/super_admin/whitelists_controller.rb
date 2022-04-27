class SuperAdmin::WhitelistsController < SuperAdminController
  def new
    @whitelist = Whitelist.new(whitelist_params)
    @whitelist.validate
    @organisation_names = Organisation.fetch_organisations_from_register
  end

  def create
    @whitelist = Whitelist.new(whitelist_params)
    if @whitelist.save
      publish_email_domains_regex
      publish_email_domains_list

      redirect_to new_super_admin_whitelist_path,
                  notice: "Organisation has been added to the allow list"
    else
      redirect_to new_super_admin_whitelist_path(whitelist: { step: Whitelist::FOURTH }),
                  notice: "There was an error, please try again"
    end
  end

private

  def publish_email_domains_regex
    UseCases::Administrator::PublishSignupWhitelist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch("S3_SIGNUP_WHITELIST_BUCKET"),
        key: ENV.fetch("S3_SIGNUP_WHITELIST_OBJECT_KEY"),
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsRegex.new,
    ).execute
  end

  def publish_email_domains_list
    UseCases::Administrator::PublishSignupWhitelist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch("S3_PRODUCT_PAGE_DATA_BUCKET"),
        key: ENV.fetch("S3_EMAIL_DOMAINS_OBJECT_KEY"),
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsList.new,
    ).execute
  end

  def whitelist_params
    params.fetch(:whitelist, {}).permit(:email_domain, :admin, :register, :organisation_name, :step)
  end
end
