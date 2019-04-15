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
      redirect_to new_admin_whitelist_path,
        notice: "Organisation has been whitelisted"
    else
      # TODO: Test this with a request spec. Feature spec can't achieve it
      redirect_to new_admin_whitelist_path(step: "fourth"),
        notice: 'There was an error, please try again'
    end
  end

private

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
      params[:whitelist][:step] = "fourth"
    else
      params[:whitelist][:organisation_name_valid] = true
    end
  end

  def email_domain_needs_validation?
    params.dig(:whitelist, :email_domain).present?
  end

  def validate_email_domain
    @email_domain = AuthorisedEmailDomain.new(name: whitelist_params.dig(:email_domain))
    if @email_domain.invalid?
      params[:whitelist][:step] = "fifth"
    end
  end

  def whitelist_params
    params.require(:whitelist).permit(:email_domain, :organisation_name, :organisation_name_valid)
  end
end
