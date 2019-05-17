class Admin::LocationsController < AdminController
  def index
    @locations = Location.all
  end
end
