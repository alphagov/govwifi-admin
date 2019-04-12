class Admin::WhitelistsController < AdminController
  def new; end

  def create
    whitelisted_details = Whitelist.new(
      organisation_name: whitelist_params[:organisation_name],
      email_domain: whitelist_params[:email_domain]
    )
    if whitelisted_details.save
      redirect_to new_admin_whitelist_path, notice: "Saved"
    end
  end

private

  def whitelist_params
    params.permit(:email_domain, :organisation_name)
  end
end
