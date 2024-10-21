class SuperAdmin::WifiAdminSearchesController < ApplicationController
  include SuperUserConcern

  def show
    @form = SearchForm.new(search_term_params)
  end

  def create
    @form = SearchForm.new(search_term_params)
    @form_valid = @form.valid?
    @user = @form_valid ? User.search(@form.search_term) : nil
    render :show
  end

private

  def search_term_params
    params.fetch(:search_form, {}).permit(:search_term)
  end
end
