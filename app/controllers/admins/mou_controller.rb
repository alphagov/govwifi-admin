class Admins::MouController < ApplicationController
  before_action :authorise_admin

  def index
    @mou = AdminConfig.mou
  end

  def update
    Organisation.find(params[:id]).signed_mou.attach(params[:signed_mou])
    redirect_to organisations_path
  end

  def create
    AdminConfig.mou.unsigned_document.attach(params[:unsigned_document])
    redirect_to admins_mou_index_path
  end

private

  def authorise_admin
    redirect_to root_path unless current_user.admin?
  end
end
