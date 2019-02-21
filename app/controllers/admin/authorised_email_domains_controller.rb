class Admin::AuthorisedEmailDomainsController < AdminController
  def index
    @authorised_email_domains = AuthorisedEmailDomain.all
  end

  def new
    @authorised_email_domain = AuthorisedEmailDomain.new
  end

  def create
    @authorised_email_domain = AuthorisedEmailDomain.new(authorised_email_params)

    if @authorised_email_domain.save
      UseCases::Administrator::PublishSignupWhitelist.new(
        destination_gateway: Gateways::S3.new(
          bucket: ENV.fetch('S3_SIGNUP_WHITELIST_BUCKET'),
          key: ENV.fetch('S3_SIGNUP_WHITELIST_OBJECT_KEY')
        ),
        source_gateway: Gateways::AuthorisedEmailDomains.new,
        presenter: UseCases::Administrator::CreateSignupWhitelist.new
      ).execute

      redirect_to admin_authorised_email_domains_path, notice: "#{@authorised_email_domain.name} authorised"
    else
      render :new
    end
  end

  def destroy
    authorised_email_domain = AuthorisedEmailDomain.find_by(id: params.fetch(:id))
    authorised_email_domain.destroy

    redirect_to admin_authorised_email_domains_path, notice: "#{authorised_email_domain.name} has been removed"
  end

private

  def authorised_email_params
    params.require(:authorised_email_domain).permit(:name)
  end
end
