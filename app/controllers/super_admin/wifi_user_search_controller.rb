class SuperAdmin::WifiUserSearchController < SuperAdminController
  def search
    @search = LogsSearch.new(search_params)
    if @search.valid?
      @wifi_user = WifiUser.search(@search.search_term.gsub(" ", ""))
    end

    render "logs_searches/contact"
  end

private

  def search_params
    params.require(:logs_search).permit(:search_term)
  end
end
