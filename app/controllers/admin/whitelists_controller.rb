class Admin::WhitelistsController < AdminController
  def new; end

  def create
    whitelisted_name = CustomOrganisationName.new(name: params[:organisation_name])
    if whitelisted_name.save
      email_domain = AuthorisedEmailDomain.create(name: whitelist_params[:email_domain])
      redirect_to new_admin_whitelist_path, notice: "Saved"
    end
  end

private

  def whitelist_params
    params.permit(:email_domain, :organisation_name)
  end
end
