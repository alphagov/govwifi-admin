class SuperAdmin::WifiUserSearchesController < SuperAdminController
  def show; end

  def create
    if search_term.blank?
      flash.now[:alert] = "Search term can't be blank"
    else
      @wifi_user = WifiUser.search(search_term.gsub(" ", ""))
    end
    render :show
  end

private

  def search_term
    params[:search_term]
  end
end
