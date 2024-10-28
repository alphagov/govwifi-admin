class SuperAdmin::LocationsController < SuperAdminController
  def index
    @locations = Location.order("#{sort_column} #{sort_direction}").includes(:organisation)
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(key_params)
      redirect_to super_admin_locations_path
    else
      render :edit
    end
  end

private

  def sortable_columns
    %w[address]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "address"
  end

  def sort_direction
    directions = %w[asc]
    directions.include?(params[:direction]) ? params[:direction] : directions.first
  end

  def key_params
    params.require(:location).permit(:radius_secret_key)
  end
end
