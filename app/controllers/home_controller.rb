class HomeController < ApplicationController
  def index
    return redirect_to admin_organisations_path if current_user.super_admin?

    redirect_to setup_instructions_path unless current_organisation.ips.present?

    @ips = current_organisation.ips
    @locations = current_organisation.locations
    @team_members = current_organisation.users
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]

    @connections = get_unique_user_requests.execute(date_range: 1.day.ago).fetch(:connection_count)
  end

private

  def radius_ips
    view_radius = UseCases::Organisation::ViewRadiusIPAddresses.new(organisation_id: current_organisation.id)
    view_radius.execute
  end

  def get_unique_user_requests
    UseCases::Administrator::GetUniqueUserRequests.new(
      authentication_logs_gateway: Gateways::UniqueConnections.new(
        ips: current_organisation.ips.map(&:address)
      )
    )
  end
end
