class SuperAdmin::WifiUserSearchesController < ApplicationController
  include SuperUserConcern

  def show
    @form = SearchForm.new(search_term_params)
  end

  def create
    @form = SearchForm.new(search_term_params)
    @form_valid = @form.valid?
    @wifi_user = @form_valid ? WifiUser.search(@form.search_term) : nil
    render :show
  end

  def confirm_destroy
    @form = SearchForm.new(search_term_params)
    @form_valid = @form.valid?
    @wifi_user = @form_valid ? WifiUser.search(@form.search_term) : nil
  end

  def destroy
    @form = SearchForm.new(search_term_params)
    @form_valid = @form.valid?
    @wifi_user = @form_valid ? WifiUser.search(@form.search_term) : nil

    flash[:notice] = "#{@wifi_user.username} (#{@wifi_user.contact}) has been removed"
    notify_user

    @wifi_user.destroy!

    redirect_to super_admin_wifi_user_search_path
  end

private

  def search_term_params
    params.fetch(:search_form, {}).permit(:search_term)
  end

  def notify_user
    if @wifi_user.mobile?
      GovWifiMailer.user_account_removed_sms(
        @wifi_user.contact,
      ).deliver_now
    else
      GovWifiMailer.user_account_removed_email(
        @wifi_user.contact,
      ).deliver_now
    end
  end
end
