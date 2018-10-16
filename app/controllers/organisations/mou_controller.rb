class Organisations::MouController < ApplicationController
  def index
    @mou = AdminConfig.mou
  end

  def create
    current_organisation.signed_mou.attach(params[:signed_mou])
    flash[:notice] = "MOU uploaded successfully."
    redirect_to organisations_mou_index_path
  end
end
