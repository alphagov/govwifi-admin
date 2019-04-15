class Admin::WhitelistsController < AdminController
  def new
    @whitelist ||= Whitelist.new

    if organisation_name_submitted? && organisation_name_needs_validation?
      @organisation_name = CustomOrganisationName.new(name: whitelist_params.dig(:organisation_name))
      if @organisation_name.invalid?
        params[:whitelist][:step] = "fourth"
      else
        params[:whitelist][:organisation_name_valid] = true
      end
    end

    if params.dig(:whitelist, :email_domain).present?
      @email_domain = AuthorisedEmailDomain.new(name: whitelist_params.dig(:email_domain))
      if @email_domain.invalid?
        params[:whitelist][:step] = "fifth"
      end
    end

    # validate each form here individually
    # if params[organisation_name].present? validate it

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
      redirect_to new_admin_whitelist_path(step: "fourth")
    end
  end

private

  def organisation_name_submitted?
    params.dig(:whitelist, :organisation_name).present?
  end

  def organisation_name_needs_validation?
    !!!whitelist_params.dig(:organisation_name_valid)
  end

  def whitelist_params
    params.require(:whitelist).permit(:email_domain, :organisation_name, :organisation_name_valid)
  end
end
