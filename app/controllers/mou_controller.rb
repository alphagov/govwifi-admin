class MouController < ApplicationController
  def index; end

  def upload
    current_organisation.signed_mou.attach(params[:signed_mou])
    redirect_to mou_index_path
  end
  
end 
