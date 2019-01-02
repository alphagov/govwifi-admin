class LogsSearchController < ApplicationController
  def new
    @search = LogsSearch.new(by: params[:by])
  end

  def create
    @search = LogsSearch.new(search_params)

    if @search.valid?
      redirect_to logs_path(@search.params)
    else
      render :new
    end
  end
end

# case params[:by]
# when 'username'

#   redirect_to logs_path(username: params[:term])
# when 'ip'
#   redirect_to logs_path(ip: params[:term])
# else
#   redirect_to new_logs_search_path
# end
