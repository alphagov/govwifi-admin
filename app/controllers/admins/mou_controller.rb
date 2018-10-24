class Admins::MouController < ApplicationController
  before_action :authorise_admin

  def index
    @mou = AdminConfig.mou
  end

  def create
    params[:id].present? ? attach_to_organisation : attach_to_template
  end

private

  def attach_to_organisation
    Organisation.find(params[:id]).signed_mou.attach(params[:signed_mou])
    flash[:notice] = "MOU uploaded successfully."
    redirect_to organisations_path
  end

  def attach_to_template
    AdminConfig.mou.unsigned_document.attach(params[:unsigned_document])
    flash[:notice] = "MOU template uploaded successfully."
    redirect_to admins_mou_index_path
  end

  def authorise_admin
    redirect_to root_path unless current_user.admin?
  end
end
