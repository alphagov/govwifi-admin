class Admin::WhitelistsController < AdminController
  def new
    @whitelist ||= Whitelist.new
  end

  def create
    @whitelist = Whitelist.new(
      organisation_name: whitelist_params[:organisation_name],
      email_domain: whitelist_params[:email_domain]
    )
    if @whitelist.save
      redirect_to new_admin_whitelist_path, notice: "Saved"
    else
      redirect_to new_admin_whitelist_path(step: "fourth")
    end
  end

private

  def whitelist_params
    params.require(:whitelist).permit(:email_domain, :organisation_name)
  end
end
