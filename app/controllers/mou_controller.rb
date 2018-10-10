class MouController < ApplicationController
  def index; end

  def update
    Organisation.find(params[:id]).signed_mou.attach(params[:signed_mou])
    redirect_to organisations_path
  end

  def upload
    current_organisation.signed_mou.attach(params[:signed_mou])
    redirect_to mou_index_path
  end

  def admin
    render 'admin'
  end

  def admin_upload
    Mou.first.unsigned_template.attach(params[:unsigned_template])
    redirect_to admin_mou_index_path
  end
end
