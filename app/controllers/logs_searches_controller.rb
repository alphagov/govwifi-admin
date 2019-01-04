class LogsSearchesController < ApplicationController
  def create
    @search = LogsSearch.new(search_params)

    if !@search.first_step && @search.valid?
      redirect_to logs_path(@search.by.to_sym => @search.term)
    else
      render @search.by
    end
  end

  def ip
    @search = LogsSearch.new(by: 'ip')
  end

  def username
    @search = LogsSearch.new(by: 'username')
  end

private

  def search_params
    params.require(:logs_search).permit(:by, :term, :first_step)
  end
end
