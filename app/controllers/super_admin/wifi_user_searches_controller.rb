class SuperAdmin::WifiUserSearchesController < SuperAdminController
  def show
    @form = SearchForm.new(search_term_params)
  end

  def create
    @form = SearchForm.new(search_term_params)
    @form_valid = @form.valid?
    @wifi_user = @form_valid ? WifiUser.search(@form.search_term) : nil
    render :show
  end

private

  def search_term_params
    params.fetch(:search_form, {}).permit(:search_term)
  end
end
