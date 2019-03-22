class Admin::LogsSearchesController < AdminController
  def create
    @search = LogsSearch.new(search_params)

    @search.first_step ? filter_choice : term_choice
  end

  def filter_choice
    if @search.filter.present?
      render @search.filter
    else
      @search.errors.add(:filter, "can't be blank")
      render 'new'
    end
  end

  def username
    @search = LogsSearch.new(filter: 'username')
  end

private

  def search_params
    params.require(:logs_search).permit(:filter, :term, :first_step)
  end
end
