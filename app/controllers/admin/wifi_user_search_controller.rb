class Admin::WifiUserSearchController < AdminController
  def search
    if search_term.blank?
      flash.now[:alert] = "Search term can't be blank"
    else
      @wifi_user = WifiUser.search(search_term.gsub(' ', ''))
    end

    render action: 'lookup'
  end

private

  def search_term
    params[:search_term]
  end
end
