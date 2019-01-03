class LogsSearchesController < ApplicationController
  def new
    case params[:choice]
    when 'username'
      redirect_to username_new_logs_search_path
    when 'ip'
      redirect_to ip_new_logs_search_path
    else
      render 'choice'
    end
  end

  def username
    @search = LogsSearch.new(by: 'username')
  end

  def ip
    @search = LogsSearch.new(by: 'ip')
  end

  def create
    @search = LogsSearch.new(search_params)

    if @search.valid?
      redirect_to logs_path(by: @search.by, term: @search.term)
    else
      render @search.by
    end
  end

private

  def search_params
    params.require(:logs_search).permit(:by, :term)
  end
end
