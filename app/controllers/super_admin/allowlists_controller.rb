class SuperAdmin::AllowlistsController < ApplicationController
  include SuperUserConcern

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
    UseCases::Administrator::PublishEmailDomainsRegex.new.publish
  end

  def publish_email_domains_list
    UseCases::Administrator::PublishEmailDomainsList.new.publish
  end

  def allowlist_params
    params.fetch(:allowlist, {}).permit(:email_domain, :admin, :register, :organisation_name, :step)
  end
end
