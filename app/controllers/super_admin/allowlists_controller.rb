class SuperAdmin::AllowlistsController < SuperAdminController
  def new
    @allowlist = Allowlist.new(allowlist_params)
    @allowlist.validate
    @organisation_names = Organisation.fetch_organisations_from_register
  end

  def create
    @allowlist = Allowlist.new(allowlist_params)
    if @allowlist.save
      publish_email_domains_regex
      publish_email_domains_list

      redirect_to new_super_admin_allowlist_path,
                  notice: "Organisation has been added to the allow list"
    else
      redirect_to new_super_admin_allowlist_path(allowlist: { step: Allowlist::FOURTH }),
                  notice: "There was an error, please try again"
    end
  end

private

  def publish_email_domains_regex
    UseCases::Administrator::PublishSignupAllowlist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch("S3_SIGNUP_ALLOWLIST_BUCKET"),
        key: ENV.fetch("S3_SIGNUP_ALLOWLIST_OBJECT_KEY"),
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsRegex.new,
    ).execute
  end

  def publish_email_domains_list
    UseCases::Administrator::PublishSignupAllowlist.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch("S3_PRODUCT_PAGE_DATA_BUCKET"),
        key: ENV.fetch("S3_EMAIL_DOMAINS_OBJECT_KEY"),
      ),
      source_gateway: Gateways::AuthorisedEmailDomains.new,
      presenter: UseCases::Administrator::FormatEmailDomainsList.new,
    ).execute
  end

  def allowlist_params
    params.fetch(:allowlist, {}).permit(:email_domain, :admin, :register, :organisation_name, :step)
  end
end
